# Seed data for LegalSkill Hub

puts "Cleaning database..."
Skill.destroy_all
VideoResource.destroy_all
Category.destroy_all

puts "Creating categories..."
categories = [
  { name: "民事案件", description: "民事诉讼、合同纠纷、侵权责任等民事法律事务" },
  { name: "刑事案件", description: "刑事辩护、刑事代理、取保候审等刑事法律服务" },
  { name: "行政案件", description: "行政复议、行政诉讼、行政赔偿等行政法律事务" },
  { name: "公司法务", description: "公司设立、股权激励、合规审查等公司法律服务" },
  { name: "知识产权", description: "专利、商标、著作权等知识产权法律保护" }
]

categories.each do |cat_data|
  Category.create!(cat_data)
end

puts "Created #{Category.count} categories"

puts "Creating video resources..."
民事 = Category.find_by(name: "民事案件")
刑事 = Category.find_by(name: "刑事案件")
知产 = Category.find_by(name: "知识产权")
公司 = Category.find_by(name: "公司法务")

videos = [
  { title: "合同法实务精讲", bilibili_url: "https://www.bilibili.com/video/BV1xx411c7Xg", duration: "45:20", category: 民事, views_count: 8234 },
  { title: "刑事辩护策略与技巧", bilibili_url: "https://www.bilibili.com/video/BV1xx411c7Xh", duration: "52:15", category: 刑事, views_count: 12567 },
  { title: "知识产权保护实务", bilibili_url: "https://www.bilibili.com/video/BV1xx411c7Xi", duration: "38:42", category: 知产, views_count: 6891 },
  { title: "劳动争议案件处理", bilibili_url: "https://www.bilibili.com/video/BV1xx411c7Xj", duration: "41:33", category: 民事, views_count: 9456 },
  { title: "公司并购法律实务", bilibili_url: "https://www.bilibili.com/video/BV1xx411c7Xk", duration: "56:28", category: 公司, views_count: 5432 },
  { title: "民事证据收集与运用", bilibili_url: "https://www.bilibili.com/video/BV1xx411c7Xl", duration: "48:15", category: 民事, views_count: 7890 }
]

videos.each do |video_data|
  VideoResource.create!(video_data)
end

puts "Created #{VideoResource.count} video resources"

puts "Creating skills..."
skills = [
  {
    title: "离婚案件技能包",
    description: "包含完整离婚诉讼文书模板、财产分割计算工具、抚养权争议应对策略、AI辅助案例检索提示词。适用于各类离婚案件，包括协议离婚、诉讼离婚、涉外离婚等场景。提供标准化文书模板18个，覆盖起诉状、答辩状、财产清单、抚养费计算表等核心文件。配套AI提示词可快速生成个性化法律文书，大幅提升办案效率。",
    price: 99,
    category: 民事,
    author_name: "陈律师",
    template_count: 18,
    download_count: 1234,
    rating: 4.8
  },
  {
    title: "刑事辩护全流程",
    description: "涵盖从会见、取保候审到庭审辩护的全套文书模板，附带AI辅助证据分析提示词与量刑建议生成工具。包含侦查阶段、审查起诉阶段、审判阶段各类法律文书。提供会见笔录模板、取保候审申请书、辩护词范本等25个实用模板。AI工具可辅助进行案情分析、证据梳理、量刑预测，显著提升辩护质量。",
    price: 99,
    category: 刑事,
    author_name: "李律师",
    template_count: 25,
    download_count: 2567,
    rating: 4.9
  },
  {
    title: "股权激励方案设计",
    description: "创业公司股权激励完整方案模板，包含期权池设计、员工激励协议、AI辅助估值计算与风险提示生成。涵盖期权授予协议、股权激励计划、员工持股平台设立文件等12个专业模板。配套估值计算工具与风险分析系统，帮助企业合法合规设计股权激励方案，有效激励核心团队。",
    price: 99,
    category: 公司,
    author_name: "王律师",
    template_count: 12,
    download_count: 876,
    rating: 4.7
  },
  {
    title: "行政诉讼实战",
    description: "行政复议与诉讼全流程指南，包含起诉状、证据清单模板，AI辅助行政法规检索与适用建议。提供行政起诉状、行政复议申请书、证据目录等15个核心文书模板。AI工具可快速检索相关行政法规与判例，辅助律师精准适用法律条文，提升行政案件胜诉率。",
    price: 99,
    category: Category.find_by(name: "行政案件"),
    author_name: "赵律师",
    template_count: 15,
    download_count: 654,
    rating: 4.6
  },
  {
    title: "合同纠纷处理方案",
    description: "买卖、服务、租赁等常见合同纠纷处理模板，包含违约责任认定、损失计算、AI辅助案例检索。覆盖买卖合同、服务合同、租赁合同等多种合同类型，提供20个实用文书模板。配备违约金计算工具、损失评估表、案例智能检索系统，帮助律师快速处理各类合同纠纷。",
    price: 99,
    category: 民事,
    author_name: "周律师",
    template_count: 20,
    download_count: 1890,
    rating: 4.9
  },
  {
    title: "投融资法律文件包",
    description: "天使轮到C轮的投资协议模板、尽职调查清单、股东协议、AI辅助估值分析与风险预警系统。包含投资协议、股东协议、对赌条款、尽职调查清单等22个专业文件。配套估值分析工具与风险预警系统，帮助律师为客户提供全方位投融资法律服务，保障交易安全。",
    price: 99,
    category: 公司,
    author_name: "吴律师",
    template_count: 22,
    download_count: 743,
    rating: 4.8
  },
  {
    title: "劳动仲裁全攻略",
    description: "劳动争议仲裁申请、证据收集、庭审策略全套文书模板，AI辅助赔偿金额计算与法律依据检索。包含仲裁申请书、答辩状、证据清单等16个实用模板。提供经济补偿金计算器、加班费计算工具、相关法律条文智能检索功能，助力律师高效处理劳动纠纷案件。",
    price: 99,
    category: 民事,
    author_name: "孙律师",
    template_count: 16,
    download_count: 1567,
    rating: 4.7
  },
  {
    title: "知识产权维权工具包",
    description: "专利、商标、著作权侵权诉讼全流程文书模板，AI辅助侵权比对分析与损害赔偿计算。涵盖侵权警告函、起诉状、证据保全申请等14个专业文书。配备侵权比对工具、损害赔偿计算器、判例智能检索系统，帮助律师快速完成知识产权维权工作。",
    price: 99,
    category: 知产,
    author_name: "郑律师",
    template_count: 14,
    download_count: 923,
    rating: 4.8
  }
]

skills.each do |skill_data|
  Skill.create!(skill_data)
end

puts "Created #{Skill.count} skills"

puts "Seed data created successfully!"
puts "Summary:"
puts "  - #{Category.count} categories"
puts "  - #{VideoResource.count} video resources"
puts "  - #{Skill.count} skills"
