# Vitiligo

Development of a Multi-Target Strategy for the Treatment of Vitiligo via Machine Learning and Network Analysis Methods. Jiye Wang, Lin Luo, Qiong Ding, Zengrui Wu, Yayuan Peng, Jie Li, Xiaoqin Wang, Weihua Li, Guixia Liu, Bo Zhang, Yun Tang. Under review.

Vitiligo is a complex disorder characterized by the loss of pigment in the skin. The current therapeutic strategies are limited. The identification of novel drug targets and candidates is highly challenging for vitiligo. In this study, we designed a systematic framework to discover potential therapeutic targets for vitiligo via combining machine learning and network analysis together. With the framework, we had successfully predicted and experimentally validated that some potential therapeutic targets such as CDK1 and PBK were closely related to melanogenesis, and further explored the multi-target strategy of kaempferide for vitiligo through proteomics profiling. The strategy mainly included (i) the suppression of the p38 MAPK signaling pathway by inhibiting CDK1 and PBK, and (ii) the modulation of cellular redox homeostasis, especially TXN and GSH antioxidant pathways, for the purpose of melanogenesis. Meanwhile, this strategy was a novel perspective to discover novel drug candidates for vitiligo. Thus, the framework would be a useful tool to discover potential therapeutic strategies and drug candidates for complex diseases. 

![12-Vitiligo_01](https://user-images.githubusercontent.com/46025194/130734288-96574a18-ec35-4947-a151-64042c8a1a9b.png)
  Figure 1. The systematic framework to discover potential therapeutic strategies for vitiligo by combining machine learning and network analysis together.

# Dataset

All the data is available in the 'Dataset' folder, including:
  1. The information of normal and vitiligo skin samples
  2. Gene expression dataset
  3. Human protein-protein interactome dataset

# Random Forest

The folder 'Random Forest' contains the code for identifying the discrimination between normal and vitiligo patients.

# GAPR

The vitiligo protein-protein interaction subnetwork (VitNet) was constructed based on the integrated human protein-protein interactome dataset, which consisted of 466 nodes and 1583 edges. The GAPR method (Tian et al., 2017) was developed to find articulation proteins in the VitNet and analyze potential therapeutic targets for vitiligo.

Reference: Tian L, Bashan A, Shi DN, et al (2017). Articulation points in complex networks. Nat Commun 8: 14223.

# Proteome

The folder 'Proteome' contains the proteomics characterization of kaempferide in B16F10 cells.
