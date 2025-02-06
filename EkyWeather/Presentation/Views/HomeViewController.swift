//
//  ProfileViewController.swift
//  EkyWeather
//
//  Created by Eky on 21/01/25.
//

import UIKit
import SnapKit
import Combine
import FloatingPanel
import Lottie



class HomeViewController: UIViewController {
    
    private let homeViewModel = HomeViewModel(forecastUseCase: ForecastUseCaseImpl())
    
    private var cancellables = Set<AnyCancellable>()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let fpc = FloatingPanelController()
    private let lottieView = LottieAnimationView()
    private lazy var boxBackground = {
        return UIView(
            frame: CGRect(x: 0, y: 0,
                          width: self.view.bounds.width,
                          height: 500))
    }()
    
    private lazy var placeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Loading..", for: .normal)
        button.addBounceAnimation()
        button.addTarget(self, action: #selector(placeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var todayDateLabel = {
        let label = UILabel()
        label.text = Date.now.getStringFormattedDate("EEE, dd MMMM yyyy")
        return label
    }()
    
    private lazy var tempLabel = {
        let label = UILabel()
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupFloatingPanel()
        bindViewModel()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            if traitCollection.userInterfaceStyle == .dark {
                boxBackground.setGradientBackground([UIColor.primary, UIColor.accent], direction: .vertical)
            } else {
                boxBackground.setGradientBackground([UIColor.primary, UIColor.white], direction: .vertical)
            }
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        scrollView.contentInsetAdjustmentBehavior = .never
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        boxBackground.setGradientBackground([UIColor.primary, .systemBackground], direction: .vertical)
        contentView.addSubview(boxBackground)
        
        Task {
            await lottieView.loadAnimation(from: try .named("thunderstorm"))
            lottieView.loopMode = .loop
            lottieView.play()
        }
        
        placeButton.titleLabel?.font = .systemFont(ofSize: FontUtility.scaledFontSize(baseFontSize: 40, minimumFontSize: 32), weight: .bold)
        placeButton.setTitleColor(.label, for: .normal)
        todayDateLabel.font = .systemFont(ofSize: FontUtility.scaledFontSize(baseFontSize: 20, minimumFontSize: 16), weight: .medium)
        tempLabel.font = .systemFont(ofSize: FontUtility.scaledFontSize(baseFontSize: 24, minimumFontSize: 16), weight: .bold)
        
        boxBackground.addSubviews(lottieView, placeButton, todayDateLabel, tempLabel)
        placeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview().offset(20)
        }
        todayDateLabel.snp.makeConstraints { make in
            make.top.equalTo(placeButton.snp.bottom)
            make.left.equalToSuperview().offset(20)
        }
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(todayDateLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        lottieView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(tempLabel.snp.bottom)
            make.width.equalTo(240)
            make.height.equalTo(240)
        }
        
        var boxes: [UIView] = []
        let colors: [UIColor] = [
            .systemPurple,
            .systemPink,
            .systemTeal,
            .systemIndigo,
            .systemGray
        ]
        
        for i in 0..<colors.count {
            let box = UIView()
            box.backgroundColor = colors[i]
            contentView.addSubview(box)
            boxes.append(box)
        }
        
        for (index, box) in boxes.enumerated() {
            box.snp.makeConstraints { make in
                if index == 0 {
                    make.top.equalTo(boxBackground.snp.bottom).offset(20)
                } else {
                    make.top.equalTo(boxes[index-1].snp.bottom).offset(20)
                }
                make.left.right.equalToSuperview().inset(20)
                make.height.equalTo(200)
            }
        }
        
        if let lastBox = boxes.last {
            contentView.snp.makeConstraints { make in
                make.bottom.equalTo(lastBox.snp.bottom).offset(20)
            }
        }
        
    }
    
    private func setupFloatingPanel() {
        fpc.delegate = self
        
        let contentVC = HomeFloatingViewController(homeViewModel: homeViewModel)
        
        fpc.set(contentViewController: contentVC)
        fpc.layout = HomeFloatingPanelLayout()
        
        fpc.track(scrollView: contentVC.tableView)
    
        fpc.isRemovalInteractionEnabled = false

        fpc.surfaceView.appearance.cornerRadius = 40
        fpc.surfaceView.appearance.backgroundColor = .clear
        
        fpc.surfaceView.grabberHandle.barColor = .quaternaryLabel
        fpc.surfaceView.grabberHandleSize = CGSize(width: 100, height: 8)
        
        fpc.addPanel(toParent: self)
    }
    
    @objc private func placeButtonTapped() {
        
    }
    
    private func bindViewModel() {
        
        homeViewModel.requestWhenInUseAuthorization()
        homeViewModel.startUpdatingLocation()
        
        homeViewModel.$city
            .sink { [weak self] city in
                guard let city = city else { return }
                self?.placeButton.setTitle(city, for: .normal)
            }
            .store(in: &cancellables)
        
        homeViewModel.$latitude
            .combineLatest(homeViewModel.$longitude)
            .sink { [weak self] latitude, longitude in
                guard let latitude = latitude, let longitude = longitude else { return }
                self?.homeViewModel.getCurrentForecast(latitude, longitude)
                self?.homeViewModel.getOneDayForecast(latitude, longitude)
            }
            .store(in: &cancellables)
        
        homeViewModel.$currentForecast
            .receive(on: DispatchQueue.main)
            .sink { [weak self] forecast in
                let condition = WeatherCondition.getWeatherDescription(from: forecast?.weatherCode) ?? "-"
                let temp = forecast?.temperature2M?.formatted() ?? "-"
                let unit = forecast?.temperatureUnit ?? ""
                self?.tempLabel.text = "\(condition) | \(temp)\(unit)"
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.removeAll()
    }
}

extension HomeViewController: FloatingPanelControllerDelegate {
        
    func floatingPanel(_ fpc: FloatingPanelController, shouldChangeTo state: FloatingPanelState) -> Bool {
        return state != .hidden
    }
    
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {

    }

}

class HomeFloatingPanelLayout: FloatingPanelLayout {
    
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .half
    let supportedStates: Set<FloatingPanelState> = [.half, .full]
    
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(fractionalInset: 0.88, edge: .bottom, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea)
        ]
    }
}

class HomeFloatingViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    
    var homeViewModel: HomeViewModel

    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.backgroundColor = .clear
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let items = Array(1...7).map { "Item \($0)" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTranslucentBackground()
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
    }
    
    func bindViewModel() {
        homeViewModel.$oneDayForecast
            .receive(on: DispatchQueue.main)
            .sink { [weak self] forecast in
                
            }
            .store(in: &cancellables)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            if traitCollection.userInterfaceStyle == .dark {
                // Dark Mode
            } else {
                // Light Mode
            }
        }
    }
}

extension HomeFloatingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return items.count
        }
    }
    
    func tableView(_ tableView: UITableView, separatorInsetForRowAt indexPath: IndexPath) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        return UIEdgeInsets.zero
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        } else {
            return 60
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = section == 0 ? "Today" : "Next 7 Days"
        label.textAlignment = .left
        label.textColor = .titleLabel
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.3) {
            cell.alpha = 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "main_cell")
            cell.backgroundColor = .quaternarySystemFill
            
            let today = MainTodayContentView()
            cell.contentView.addSubview(today)
            today.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            return cell
        } else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            let item = items[indexPath.row]
            
            var config = cell.defaultContentConfiguration()
            config.text = item
            config.textProperties.font = .systemFont(ofSize: 16, weight: .semibold)
            config.textProperties.color = .titleLabel
            
            config.secondaryText = "Subtitle for \(item)"
            config.secondaryTextProperties.font = .systemFont(ofSize: 14)
            config.secondaryTextProperties.color = .secondaryLabel
            
            cell.contentConfiguration = config
            
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
            cell.accessoryView = UIImageView(image: UIImage(systemName: "chevron.right", withConfiguration: imageConfig))
            cell.accessoryView?.tintColor = .titleLabel
            cell.backgroundColor = .quaternarySystemFill
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

class MainTodayContentView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private lazy var hourlyCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 200)
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumLineSpacing = 8
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        return collection
    }()
    
    internal func setup() {
        backgroundColor = .quaternarySystemFill
        
        hourlyCollection.delegate = self
        hourlyCollection.dataSource = self
        
        hourlyCollection.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: "WeatherCell")
        
        addSubview(hourlyCollection)
        
        hourlyCollection.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private var hourlyTimeList: [String] { generateHourlyTimeList() }
    
    func generateHourlyTimeList() -> [String] {
        var timeList: [String] = []
        
        let calendar = Calendar.current
        let now = Date.now
        
        let currentHour = calendar.component(.hour, from: now)
        
        for offset in 0...7 {
            let newTime = calendar.date(bySettingHour: (currentHour + offset) % 24, minute: 0, second: 0, of: now)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let timeString = dateFormatter.string(from: newTime)
            timeList.append(timeString)
        }
        
        return timeList
    }
}

extension MainTodayContentView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyTimeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as? WeatherCollectionViewCell else {
            fatalError("Could not dequeue WeatherCollectionViewCell")
        }

        let item = indexPath.item == 0 ? "Now" : hourlyTimeList[indexPath.item]
        cell.configure(with: item)
        
        return cell
    }
}

class WeatherCollectionViewCell: UICollectionViewCell {
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let lottie: LottieAnimationView = {
        let animationView = LottieAnimationView()
        animationView.loopMode = .loop
        return animationView
    }()
    
    private let desc: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.preferredMaxLayoutWidth = 100
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubviews(title, lottie, desc)
        
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
        }

        lottie.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
                
        desc.snp.makeConstraints { make in
            make.top.equalTo(lottie.snp.bottom).offset(16)
            make.bottom.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
        }
        
        backgroundColor = .systemFill
        
        Task {
            await lottie.loadAnimation(from: try .named("thunderstorm"))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: String) {
        title.text = item
        desc.text = "Thunderstorm and Rain"
        
        if (!lottie.isAnimationPlaying) {
            lottie.play()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        if !lottie.isAnimationPlaying {
            lottie.play()
        }
    }

}

@available(iOS 17, *)
#Preview {
    HomeViewController()
}
