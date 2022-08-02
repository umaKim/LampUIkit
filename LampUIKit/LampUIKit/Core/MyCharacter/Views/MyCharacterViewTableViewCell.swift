        setupUI()
    private lazy var titleLabel: UILabel = {
       let lb = UILabel()
        lb.font = .robotoBold(15)
        lb.textColor = .midNavy
        lb.text = "Title"
        return lb
    }()
    
    private lazy var barView: HorizontalFillBar = {
        let uv = HorizontalFillBar(height: 13, fillerColor: .systemRed, trackColor: .whiteGrey)
        uv.layer.cornerRadius = 13 / 2
        uv.widthAnchor.constraint(equalToConstant: UIScreen.main.width - 32).isActive = true
        return uv
    }()
    
    private lazy var numberLabel = CapsuleLabelView("11/50")
    
    private lazy var seperateView = DividerView()
    
    private func setupUI() {
        backgroundColor = .greyshWhite
        
        let sv = UIStackView(arrangedSubviews: [titleLabel, barView, numberLabel, seperateView])
        sv.distribution = .equalSpacing
        sv.alignment = .center
        sv.axis = .vertical
        
        [sv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: leadingAnchor),
            sv.trailingAnchor.constraint(equalTo: trailingAnchor),
            sv.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            sv.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        ])
    }
