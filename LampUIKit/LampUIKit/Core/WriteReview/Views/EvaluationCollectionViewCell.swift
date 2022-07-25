    private lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 15, weight: .semibold)
        return lb
    }()
        setupUI()
    private func setupUI() {
        [titleLabel].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    public func configure(with model: EvaluationModel) {
        titleLabel.text = model.title
        
        if model.isSelected {
            self.layer.borderColor = UIColor.midNavy.cgColor
            self.titleLabel.textColor = .midNavy
        } else {
            self.layer.borderColor = UIColor.systemGray.cgColor
            self.titleLabel.textColor = .systemGray
        }
    }
