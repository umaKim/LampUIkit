    private lazy var backgroundImageView: UIImageView = {
       let uv = UIImageView()
        uv.image = UIImage(named: "ticketBackground")
        return uv
    }()
    
    private lazy var visitiedDateLabel: UILabel = {
       let lb = UILabel()
        lb.font = .systemFont(ofSize: 18, weight: .semibold)
        lb.textColor = .black
        return lb
    }()
    
    private lazy var locationNameLabel: UILabel = {
       let lb = UILabel()
        lb.font = .systemFont(ofSize: 18, weight: .semibold)
        lb.textColor = .midNavy
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    private func setupUI() {
        backgroundView = backgroundImageView
        configureShadow()
        
        [visitiedDateLabel, locationNameLabel].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            visitiedDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 46),
            visitiedDateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 36),
            
            locationNameLabel.leadingAnchor.constraint(equalTo: visitiedDateLabel.leadingAnchor),
            locationNameLabel.topAnchor.constraint(equalTo: visitiedDateLabel.bottomAnchor, constant: 20),
        ])
