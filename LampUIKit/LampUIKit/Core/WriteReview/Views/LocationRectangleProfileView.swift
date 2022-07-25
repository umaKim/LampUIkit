    private lazy var profileImageView: UIImageView = {
        let uv = UIImageView()
        uv.image = .gear
        uv.widthAnchor.constraint(equalToConstant: 72).isActive = true
        return uv
    }()
    
    private lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "경복궁"
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 15, weight: .semibold)
        return lb
    }()
    
    private lazy var addrLabel: UILabel = {
        let lb = UILabel()
        lb.text = "서울시 종로구 시작로 191"
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 12, weight: .semibold)
        return lb
    }()
        let labelSv = UIStackView(arrangedSubviews: [titleLabel, addrLabel])
        labelSv.axis = .vertical
        labelSv.distribution = .fill
        labelSv.alignment = .leading
        
        let totalSv = UIStackView(arrangedSubviews: [profileImageView, labelSv])
        totalSv.axis = .horizontal
        totalSv.distribution = .fill
        totalSv.alignment = .fill
       
        [totalSv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            totalSv.leadingAnchor.constraint(equalTo: leadingAnchor),
            totalSv.trailingAnchor.constraint(equalTo: trailingAnchor),
            totalSv.bottomAnchor.constraint(equalTo: bottomAnchor),
            totalSv.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
    
