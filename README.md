README
Topic: Technology and Eco-Efficiency: Evidence from Nepal’s Cement Sector
Yale School of the Environment - Environmental Data Science Certificate Program
Student: Rajesh Sharma | Submitted: April 2026

1.	Background and Research questions
Nepal’s cement industry has expanded rapidly in the post-earthquake period, playing a central role in infrastructure development and economic growth. However, this expansion has been accompanied by rising CO₂ emissions, driven by heavy reliance on fossil fuels, high-limestone composition, and the continued use of inefficient and outdated production technologies. Despite the sector’s growing environmental footprint, there is currently no standardized or mandatory carbon emission reporting at the firm level in Nepal. This absence of reliable emissions data creates a critical barrier for policymakers, limiting their ability to design targeted, evidence-based environmental regulations and monitor progress toward national climate commitments.
In addition, significant heterogeneity exists across firms in terms of production processes and technological adoption, suggesting that environmental performance may vary widely within the industry. Yet, in the absence of systematic measurement, these differences remain largely undocumented. This lack of transparency not only constrains academic inquiry but also weakens institutional efforts toward sustainable industrial transformation.
Against the backdrop, this study seeks to address these gaps by generating firm-level evidence on emissions and environmental efficiency in Nepal’s cement sector. Specifically, it examines how total CO₂ emissions have evolved over time, evaluates differences in eco-efficiency when both economic output and environmental costs are jointly considered, and assesses whether technological adoption plays a significant role in shaping firms’ environmental performance. By doing so, the study aims to provide a robust empirical foundation for informed policymaking and support Nepal’s transition toward a low-carbon industrial pathway.
Research Question:
•	How have tCO₂ emissions from Nepalese cement manufacturing firms changed over time?
•	Does technological adoption influence the eco-efficiency of cement firms in Nepal?

2.	Methodology
Data Source and Variables Calculation
As most firms in the sample are privately owned and do not publicly disclose detailed production or energy consumption details, the required data were obtained through direct engagement with firms. This approach enabled access to otherwise unavailable operational data and ensured a high level of granularity and reliability. The dataset comprises annual financial reports as well as firm-level observations from 2020 to 2026, including cement and clinker production volumes, along with details of energy consumption data such as coal, diesel, and electricity usage.
Estimation of Greenhouse Gas Emissions
Greenhouse gas (GHG) emissions—including CO₂, CH₄, and N₂O—are estimated following guidelines provided by the Intergovernmental Panel on Climate Change (IPCC)  and the International Energy Agency (IEA). Emissions are calculated using standard conversion factors (e.g., tCO₂ per ton of coal, per liter of diesel, and per kWh of electricity). Each gas is weighted by its Global Warming Potential (GWP) to derive carbon dioxide equivalent (tCO₂e) values.
All emission variables are measured at the firm–year level and expressed in metric tons of CO₂ equivalent (tCO₂e), defined as follows:
•	Scope 1 Emissions (tCO₂e): Direct emissions from on-site fuel combustion (coal and diesel) and process emissions from limestone calcination during clinker production.
•	Scope 2 Emissions (tCO₂e): Indirect emissions associated with purchased electricity consumption.
•	Total Emissions (tCO₂e): The aggregate of Scope 1 and Scope 2 emissions.
Data cleaning and interpolation techniques are applied to address missing observations and ensure consistency across firms and time periods.
Eco-Efficiency Measurement
To evaluate environmental performance, the study employs a Slack-Based Measure (SBM) model within the Data Envelopment Analysis (DEA) framework under the Constant Returns to Scale (CRS) assumption. The model integrates both economic and environmental dimensions by treating raw material cost as inputs, production/revenue as a desirable output, and GHG emissions (tCO₂e) as an undesirable output. By explicitly accounting for input excesses and output shortfalls, the SBM approach provides a more comprehensive assessment of inefficiency, enabling the estimation and ranking of firm-level eco-efficiency scores.
Technology Classification
Firms are categorized into high and low technology adoption groups based on the type of production equipment used, including FLSmidth systems, Vertical Roller Mills (VRM), modern rotary kilns, and ball mills. To operationalize this classification, a Technology–Emission Index is constructed as follows: a score of 4 represents advanced integrated systems (VRM combined with waste heat recovery and an efficient kiln), 3 denotes VRM with a modern kiln, 2 reflects a modern kiln without advanced grinding technology, and 1 indicates the use of ball mills or other outdated systems.
	Score Description
4	Advanced integrated system (VRM + waste heat recovery + efficient kiln)
3	VRM with modern kiln
2	Modern kiln without advanced grinding
1	Ball mill or outdated systems

This index captures variation in technological sophistication and its potential environmental implications. Based on the score distribution, firms with a score of 3 and above are classified as high technology adopters, while those with a score below 3 are categorized as low technology adopters.
Statistical Method
An independent sample t-test is conducted to assess whether differences in technological adoption significantly influence firms’ eco-efficiency scores. This analysis provides empirical evidence on the role of technology in shaping environmental performance within Nepal’s cement industry.

3.	Results: Figures and Statistical tests
•	Descriptive Details of Main Variables
•	Plot: Total Yearly tCO2 Emission
•	Plot: Average Yearly tCO2 Emission
•	Plot: Combined both, Total and Average tCO2 Emission
•	Plot: Year on Year Percentage Growth of Total Emission
•	Plot: Top Five CO2 Emitting Firms
•	Plot: Emission Percentage by Top Five Firms
•	Plot: Total Emission of all Individual Cement Companies (ordered according to their total emissions)
•	Finding Eco- Efficient Firms using DEA Method
•	Statistical Test: Use Eco-Efficiency Score (pooled_eff) with respect to Technology Category for T-Test

4.	Conclusion:
•	Total emissions show an overall increasing trend from 2020 to 2024, rising from approximately 4.6 million tCO₂ to a peak of about 8.8 million tCO₂, indicating a substantial growth in environmental impact over the period. Although there is a noticeable decline in 2025 to around 7.6 million tCO₂, emissions remain significantly higher than the initial years. This pattern suggests that while there may be recent improvements or adjustments, sustained efforts are still required to effectively control and reduce emissions over time.
•	The top five most polluting cement firms account for nearly half (48.6%) of total sectoral emissions, with Shivam Hongshi as the largest contributor, followed by Shaurya, Sarbottam, Shivam, and Udaypur. Their consistently high average emissions highlight a clear concentration, suggesting that targeted policies and technological interventions in this small group could yield substantial reductions in overall sectoral emissions.
•	Firms that adopt more advanced production technologies demonstrate significantly higher eco-efficiency, supporting the hypothesis that technological modernization can enhance environmental performance in Nepal’s cement industry.


