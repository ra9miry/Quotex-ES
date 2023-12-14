//
//  InfoViewController.swift
//  Quotex ES
//
//  Created by Радмир Тельман on 08.12.2023.
//

import UIKit
import SnapKit

class InfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private lazy var headerView: UIView = {
        let header = UIView()
        header.backgroundColor = UIColor(named: "tabbar")
        header.layer.cornerRadius = 20
        header.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return header
    }()

    private lazy var labelForInfoName: UILabel = {
        let label = UILabel()
        label.text = "Useful Information"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    private lazy var infoTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 120
        tableView.register(InfoTableViewCell.self, forCellReuseIdentifier: "InfoCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        return tableView
    }()

    private var infoItems: [InfoItem] = []
    private var infoMassive: [InfoMassive] = []

    override func viewDidLoad() {
         super.viewDidLoad()
         view.backgroundColor = .black

         setupViews()
         setupConstraints()
         setupInfoData()
        setupForAboutData()
        navigationItem.hidesBackButton = true
     }
    
    private func setupViews() {
        view.addSubview(headerView)
        view.addSubview(labelForInfoName)
        view.addSubview(infoTableView)
    }

    private func setupConstraints() {
        headerView.snp.makeConstraints() { make in
            make.top.equalToSuperview().offset(0)
            make.leading.trailing.equalToSuperview().offset(0)
            make.height.equalTo(115)
        }

        labelForInfoName.snp.makeConstraints() { make in
            make.top.equalTo(headerView.snp.top).offset(66)
            make.centerX.equalTo(headerView.snp.centerX)
        }

        infoTableView.snp.makeConstraints() { make in
            make.top.equalTo(headerView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }

    private func setupInfoData() {
        infoItems = [
            InfoItem(imageName: "i1", description: "Morgan Stanley Says These 3 Semiconductor Stocks Are Hot Buys Right Now"),
            InfoItem(imageName: "i2", description: "The savvy investor's playbook: a comprehensive guide for navigating the financial landscape"),
            InfoItem(imageName: "i3", description: "Bill Gates Is Pulling In Nearly $500 Million In Annual Dividend Income. Here Are The 5 Stocks Generating The Most Cash Flow For His Portfolio"),
            InfoItem(imageName: "i4", description: "Investing 101: a practical guide for new investors"),
            InfoItem(imageName: "i5", description: "Apple is on track to be the first $4 trillion company by the end of 2024, Wedbush says"),
            InfoItem(imageName: "i6", description: "Macy's mulls $5.8 billion buyout offer, as stock surges after the news"),
            InfoItem(imageName: "i7", description: "Why Comments by Nvidia's CFO Pushed Intel Stock Into Rally Mode This Morning"),
            InfoItem(imageName: "i8", description: "If You Invested $10,000 in Verizon in 2013, This Is How Much You Would Have Today"),
        ]
        infoTableView.reloadData()
    }
    
    private func setupForAboutData() {
        infoMassive = [
            InfoMassive(imageName: "info1", description: "Morgan Stanley Says These 3 Semiconductor Stocks Are Hot Buys Right Now", additionalInfo: "Driven by the enthusiasm for all things AI, the semiconductor sector has outperformed the broader markets this year, with the SOX (the Philadelphia Semiconductor Index) – the sector’s barometer for overall performance – up by 49% year-to-date.The gains have come against a difficult backdrop and an inventory correction that has continued to play out on the device side. Yet, Morgan Stanley analyst Joseph Moore believes that as the inventory correction runs its course over the coming months, the fundamentals for devices are “turning more positive.”However, there’s a catch here. “In a perfect world,” notes the 5-star analyst, “that fundamental bottoming would be aligned with trough valuations.” But that is not the case, says Moore, given semis have bettered the overall market’s performance. So, it’s time to be picky, and here, Moore recommends a “move to an overweight position in devices.” “While we still argue for being selective, the combination of recovering fundamentals and the importance of semiconductors in early stage AI argues for a higher than market weight exposure,” Moore explained. “Generally speaking, barring macro dislocation, we are past the bottom in some areas, and for most others, the bottom is in sight. Barring economic dislocation, things should improve over the course of 2024."),
            InfoMassive(imageName: "info2", description: "The savvy investor's playbook: a comprehensive guide for navigating the financial landscape", additionalInfo: "Congratulations on taking the first step toward financial empowerment through investing! This comprehensive guide is designed to equip you with the knowledge and strategies needed to navigate the complex world of investments. Whether you're a novice or looking to refine your investment approach, this playbook has you covered.Self-Assessment and Goal Setting: Begin by assessing your financial situation, risk tolerance, and investment goals. Define short-term and long-term objectives to tailor your investment strategy to your unique needs.Building a Strong Financial Foundation: Before diving into investments, ensure your financial foundation is solid. Pay off high-interest debts, establish an emergency fund, and create a realistic budget to free up funds for investing.Explore Investment Vehicles: Familiarize yourself with various investment options, including stocks, bonds, real estate, and alternative investments. Understand the risk and return profiles of each asset class to make informed decisions.Crafting a Diversified Portfolio: Develop a well-diversified portfolio by spreading your investments across different sectors, industries, and geographic regions. Diversification helps mitigate risk and enhances the potential for consistent returns.The Importance of Research: Conduct thorough research before making investment decisions. Analyze financial statements, understand market trends, and stay informed about the companies or funds in which you plan to invest.Investment Strategies: Explore various investment strategies such as value investing, growth investing, and dividend investing. Determine which strategy aligns with your goals and risk tolerance.Stay Disciplined in Market Volatility: Market fluctuations are inevitable. Resist the temptation to make impulsive decisions during volatile times. Stay focused on your long-term goals and consider market downturns as opportunities to buy assets at a discount.Regular Portfolio Review: Schedule periodic reviews of your investment portfolio. Assess your asset allocation, rebalance if necessary, and make adjustments based on changes in your financial situation or market conditions.Tax-Efficient Investing: Understand the tax implications of your investments. Explore tax-efficient strategies, utilize tax-advantaged accounts, and consider the impact of capital gains on your overall tax liability.Continuous Learning and Adaptation: The financial landscape evolves, and so should your investment knowledge. Stay curious, keep learning, and adapt your strategies as needed. Attend workshops, read financial literature, and consider consulting with a financial advisor for personalized guidance."),
            InfoMassive(imageName: "info3", description: "Bill Gates Is Pulling In Nearly $500 Million In Annual Dividend Income. Here Are The 5 Stocks Generating The Most Cash Flow For His Portfolio", additionalInfo: "Bill Gates, the seventh richest person globally, emphasizes dividend income in his investment approach, evident in his impressive annual earnings of $464.5 million from his portfolio.Gates focuses on companies with robust dividend yields, emphasizing a commitment to consistent, long-term income streams. The Bill & Melinda Gates Foundation Trust's latest 13F filing discloses that a substantial portion of his income comes from five key stocks.Canadian National Railway Co: Canadian National Railway, a prominent North American transportation and logistics firm, is a significant part of Gates's portfolio, with 54,826,786 shares valued at about $6.33 billion. The quarterly dividend of $0.57 per share contributes to Gates's annual income of $125,005,072.08.Microsoft Corp: As the founder of Microsoft, Gates retains a substantial investment in the tech giant, with 39,286,170 shares. Following a recent dividend increase to $0.75 per share, Gates's annual income from Microsoft is an impressive $117,858,510.00, reflecting his belief in the company's innovation and market dominance.Waste Management Inc: Waste Management Inc, the largest waste management company in North America, aligns with Gates's sustainable investment principles. Gates owns 35,234,344 shares, valued at about $6.06 billion, generating an annual income of $98,656,163.20 with a $0.70 quarterly dividend per share.Caterpillar Inc: Caterpillar Inc, renowned for construction and mining equipment, is a key element of Gates's portfolio, with 7,353,614 shares valued at approximately $1.82 billion. The quarterly dividend of $1.30 per share results in an annual income of $38,238,792.80. Deere & Co: Deere & Co, a leader in agricultural and construction machinery, is a significant investment for Gates, with 3,917,693 shares valued at about $1.45 billion. The $1.35 per share dividend contributes to Gates's annual income of $21,155,542.20. These five investments collectively yield nearly $401 million in annual dividend income for Gates. While Gates's investment strategy has been highly successful, it's crucial for individual investors to tailor their approach to their unique financial situation and goals, recognizing that replicating strategies may not always align with personal risk tolerance."),
            InfoMassive(imageName: "info4", description: "Investing 101: a practical guide for new investors", additionalInfo: "Embarking on your investment journey can be both exciting and daunting. This practical guide is tailored for new investors, providing step-by-step insights to help you navigate the world of investing with confidence. Let's dive in! Financial Health Check: Begin by assessing your financial health. Calculate your net worth, review your budget, and identify areas where you can allocate funds for investing without compromising your essential needs. Define Clear Objectives: Clearly outline your investment goals. Whether it's saving for a down payment, funding education, or building wealth for retirement, having specific objectives will guide your investment strategy.Risk Tolerance Assessment: Evaluate your risk tolerance level. Understand that risk is inherent in investing, and your comfort with risk will influence the types of investments you choose. Consider your age, financial goals, and willingness to withstand market fluctuations. Educational Foundation:Equip yourself with basic investment knowledge. Learn about asset classes, investment vehicles, and key financial terms. Resources like online courses, investment books, and reputable financial websites can be valuable tools. Start Small and Diversify: Begin with a modest investment amount and diversify your portfolio. Diversification spreads risk and can enhance your potential for returns. Consider low-cost index funds or exchange-traded funds (ETFs) as accessible starting points.Choose the Right Investment Account: Explore brokerage accounts, Individual Retirement Accounts (IRAs), and employer-sponsored retirement plans. Each account type has unique benefits and tax implications, so choose one that aligns with your goals. Regular Contributions and Dollar-Cost Averaging: Make regular contributions to your investment account, even if the amounts are small. Embrace the concept of dollar-cost averaging, which involves consistently investing a fixed amount at regular intervals, reducing the impact of market volatility. Stay Informed but Avoid Overtrading:Keep abreast of market news and trends, but avoid the temptation to overtrade. Frequent buying and selling can lead to unnecessary fees and hinder your long-term returns. Focus on your investment strategy rather than short-term market fluctuations.Monitor and Rebalance: Periodically review your portfolio to ensure it aligns with your goals. Rebalance if necessary, adjusting your asset allocation based on changes in your financial situation or market conditions. Seek Guidance and Stay Patient: Don't hesitate to seek advice from financial professionals or experienced investors. Be patient, as investing is a long-term endeavor. Stay focused on your goals, and remember that consistent, informed decisions tend to yield positive results over time. With this practical guide, you're well on your way to becoming a confident and informed investor. Happy investing!"),
            InfoMassive(imageName: "info5", description: "Apple is on track to be the first $4 trillion company by the end of 2024, Wedbush says", additionalInfo: "Apple is projected to achieve a $4 trillion valuation by the end of the next year, making it the first company to reach this milestone on the stock market, as forecasted by Wedbush. The investment research firm increased its price target for Apple to $250 per share, indicating a 30% upside. Currently valued at $2.99 trillion, Apple had previously reached a historic $3 trillion valuation earlier in the year. Wedbush strategists anticipate Apple's valuation to hit $4 trillion by the end of 2024, attributing this growth to the company's pace of expansion and monetization. They also foresee a robust holiday season in 2023, driven by the iPhone 15. The firm estimates Apple could produce up to 240 million iPhone 15 units in 2024, with strong demand expected in the US and China. Despite geopolitical tensions and competition from Chinese manufacturers like Huawei, Apple remains well-positioned for significant growth. Additionally, Wedbush highlights the increasing revenue from Apple's services business, estimated to be worth up to $1.6 trillion, contributing to the stock's value. The firm sees 2024 as a golden opportunity for investors in Apple, considering the company's strong iPhone sales and the broader tech market's positive outlook."),
            InfoMassive(imageName: "info6", description: "Macy's mulls $5.8 billion buyout offer, as stock surges after the news", additionalInfo: "The long-suffering shareholders of Macy's just scored an early Christmas gift. Macy's has received a $5.8 billion buyout offer from real estate investor Arkhouse Management and asset manager Brigade Capital Management, a source familiar with the matter told Yahoo Finance late Sunday. The offer, valuing Macy's at about $21 a share, was reportedly submitted on Dec. 1. The company's board is mulling the offer. The Wall Street Journal first reported news on the offer earlier Sunday. Macy's declined to comment to Yahoo Finance. The offer price marks a 32.4% premium to Macy's closing price on Nov. 30. Shares rose 19% to close at $20.78 on Monday. To be sure, Macy's board, led by a mix of retail veterans such as former Home Depot CEO Frank Blake, has a lot to consider. For starters, Macy's all-time high stock price of $70.99 was hit on June 15, 2015, according to Yahoo Finance data. As of Friday's close, Macy's shares changed hands at $17.39. Meanwhile, just back in 2022 investment bank Cowen valued Macy's real estate holdings alone in a range of $6 billion to $8 billion. Macy's has a prized real estate portfolio, headlined by its iconic Herald Square location in New York City. Valuations from various money managers on the trophy real estate asset have ranged between $3 billion and $4 billion in the past decade. Macy's has some valuable real estate including its Herald Square location, which makes Macy's more attractive as a target. Although the company has monetized some of its real estate, there is likely more that can be done, Citi analyst Paul Lejuez said in a client note today. The company must also weigh how disruptive a buyout process could be into 2024. Macy's is smack in the middle of the holiday shopping season, with results to be published in mid to late February. In February 2024, Macy's will see longtime exec Tony Spring take over as CEO from the retiring Jeff Gennette."),
            InfoMassive(imageName: "info7", description: "Why Comments by Nvidia's CFO Pushed Intel Stock Into Rally Mode This Morning", additionalInfo: "Shares of Intel (NASDAQ: INTC) rallied out of the gate on Monday morning, adding as much as 4.3%. As of 1:32 p.m. ET, the stock was still up 4.2%. The catalyst that sent the semiconductor giant higher was comments made by Nvidia chief financial officer Colette Kress.A collaboration?It's been a banner year for Nvidia, with the hastening adoption of artificial intelligence (AI) causing a run on the graphics processing units (GPUs) used for it. As a result, demand has far outstripped supply. By some accounts, the shortage of these graphics cards could last for the coming 12 to 18 months, according to a report by technology news site Tom's Hardware.While the vast majority of these processors are manufactured by Taiwan Semiconductor Manufacturing (aka TSM), Nvidia is open to working with another foundry to ease the backlog -- namely Intel. During last week's UBS Global Technology Conference, Kress was asked if Nvidia would consider using Intel as a foundry partner to produce its state-of-the-art AI chips. The finance chief said the company would love to. After commenting on existing foundry partnerships with TSM and Samsung, Kress said: Would we love a third one? Sure. We would love a third one ... [there's] nothing that stops us from potentially adding another foundry.We've heard this story before This isn't the first time Nvidia has alluded to its willingness to share some of its chip manufacturing with Intel. Last year, Nvidia CEO Jensen Huang said the company had plans to diversify the production of its AI processors. He went on to say that Nvidia had reviewed Intel's test chip, and the results look good.Intel is a mixed bag at this point, though its foundry business is something of a high point. There are reasons to buy and to sell, and investors should do more homework to decide if the stock is right for their situation."),
            InfoMassive(imageName: "info8", description: "If You Invested $10,000 in Verizon in 2013, This Is How Much You Would Have Today", additionalInfo: "It hasn't been easy being a shareholder in Verizon Communications (NYSE: VZ). The networking and communications giant has been a poor performer. The numbers don't lie. If you had invested $10,000 into this telecom stock a decade ago and reinvested your dividends, you would be sitting on a position worth $12,600 today. If dividends were excluded, you would've experienced a 22% loss. For comparison, an S&P 500 index fund, with dividends reinvested, would've tripled your money during that same time. What issues have been holding back Verizon stock over the past decade? And is this a stock that investors should consider buying right now? Verizon's disappointing financials From a business perspective, Verizon's financial trends have been poor. For example, from 2013 to 2022, its revenues only increased by 14% in total. Plus, the company's diluted earnings per share rose by just 28% over the period. But why have its financials been so subpar? I think there are two reasons. The first is the nature of the industry in which it operates. The end market for its bread-and-butter segment, wireless services, is very mature. In Q3, its wireless services revenue grew by just 2.9% year over year to $19.3 billion. To its credit, Verizon is focusing more on growing its non-wireless operations, like broadband internet, where its subscriber count increased by 21%. But this can't really offset the burden faced by the entire business. It also doesn't help that more than 90% of the U.S. population already has a smartphone, which limits Verizon's growth potential. A saturated market opportunity is a worse situation for growth when coupled with intense competition, which is the other headwind Verizon continues to face. There are smaller regional players, as well as nationwide heavyweights like AT&T and T-Mobile. Readers are likely familiar with the aggressive promotional activity and discounts offered by these companies to lure customers from competing service providers. This situation isn't going to change anytime soon. Is now a good time to buy the stock? Despite the challenges that Verizon faces, some might still find the stock an attractive buying opportunity right now. It currently trades at a price-to-earnings ratio of 7.8. That's below its 10-year average. Also, at its current share price, the dividend Verizon pays yields a hefty 6.9%. Investors who care more about generating steady income from their holdings will find this compelling. Since Verizon delivered its latest earnings report on Oct. 24, the shares have performed well. They are up by 13% from where they stood previously, mainly because the business beat Wall Street's estimates for both revenue and earnings per share. This could be the start of better days for the stock. However, I would avoid Verizon stock. As a long-term investor who aims to beat the overall market's performance, I view it as a poor investment opportunity. The lack of meaningful growth potential for the company and the intense competition in its industry aren't favorable characteristics by any means. These realities are exacerbated by the fact that Verizon is engaged in a capital-intensive business. Capital expenditures through the first nine months of 2023 totaled $14.2 billion, accounting for 14% of revenue. Verizon must constantly spend on acquiring new wireless spectrum and developing new technologies like 5G. This explains why the enterprise carries nearly $140 billion of debt on its balance sheet. Verizon's track record of disappointing its shareholders over the past decade speaks for itself. Given the option today of investing $10,000 in either an index fund that tracks the S&P 500 or Verizon stock, I'd choose the former without any hesitation."),
        ]
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoTableViewCell

        let infoItem = infoItems[indexPath.row]
        cell.configure(with: infoItem)
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor(named: "tabbar")
        cell.selectedBackgroundView = selectedBackgroundView
        cell.contentView.backgroundColor = .back
        cell.contentView.layer.cornerRadius = 20
        cell.contentView.layer.masksToBounds = true
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.gray.cgColor
        cell.backgroundColor = .black
        cell.contentView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedInfoMassive = infoMassive[indexPath.row]
        let detailViewController = AboutViewController(infoMassive: selectedInfoMassive)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
}
