aging_medical_real_estate/
├── data/                         # 原始資料與地理座標
│   ├── lvr_landcsv114Q3/         # 內政部不動產交易資料（Q3）
│   ├── population_index/         # 行政區人口指標（高齡化）
│   │   └── aging_index_11312.csv
│   ├── medical_facilities/       # 特約健保單位資料（含年度標記）
│   │   ├── hospital_local_202510.csv
│   │   ├── hospital_regional_202510.csv
│   │   ├── clinic_202510.csv
│   │   ├── medical_center_202510.csv
│   │   └── pharmacy_202510.csv
│   └── geo/                      # 門牌座標資料（初期為新竹市）
│       └── hsinchu_address_coordinates_202510.csv
├── R/                            # 模組化 R 程式碼
│   ├── load_data.R               # 資料讀取與整合
│   ├── visualize_aging.R         # 高齡指數地圖視覺化
│   ├── visualize_medical.R       # 醫療資源分布地圖
│   └── visualize_real_estate.R   # 房地交易熱區分析
├── output/                       # 圖表與報表輸出
├── docs/                         # 專案說明與進度紀錄
│   ├── README.md                 # 本說明文件
│   ├── project_plan.md           # 專案進度與分工
│   └── data_sources.md           # 資料來源與欄位說明
├── .gitignore                    # 忽略不需追蹤的檔案
└── aging_medical_real_estate.Rproj # RStudio 專案檔






-----------------------------------------------------------------------------------


# 請根據你的實際路徑修改這個根目錄
project_root <- "C:/Users/OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO/aging_medical_real_estate"

# 建立資料夾結構
dir.create(file.path(project_root, "data", "lvr_landcsv114Q3"), recursive = TRUE)
dir.create(file.path(project_root, "data", "population_index"), recursive = TRUE)
dir.create(file.path(project_root, "data", "medical_facilities"), recursive = TRUE)
dir.create(file.path(project_root, "data", "geo"), recursive = TRUE)
dir.create(file.path(project_root, "R"), recursive = TRUE)
dir.create(file.path(project_root, "output"), recursive = TRUE)
dir.create(file.path(project_root, "docs"), recursive = TRUE)

# 建立空白檔案（可選）
file.create(file.path(project_root, "R", "load_data.R"))
file.create(file.path(project_root, "R", "visualize_aging.R"))
file.create(file.path(project_root, "R", "visualize_medical.R"))
file.create(file.path(project_root, "R", "visualize_real_estate.R"))
file.create(file.path(project_root, "docs", "README.md"))
file.create(file.path(project_root, "docs", "project_plan.md"))
file.create(file.path(project_root, "docs", "data_sources.md"))
file.create(file.path(project_root, ".gitignore"))
file.create(file.path(project_root, "aging_medical_real_estate.Rproj"))












📁 aging_medical_real_estate 資料夾結構與檔案命名說明
更新日期：2025-10-21

一、資料夾結構（請依照以下路徑建立）

aging_medical_real_estate/
├── data/                         # 原始資料與地理座標
│   ├── lvr_landcsv114Q3/         # 內政部不動產交易資料（Q3）
│   ├── population_index/         # 行政區人口指標（高齡化）
│   ├── medical_facilities/       # 特約健保單位資料（含年度標記）
│   └── geo/                      # 門牌座標資料（依地區與年月命名）
├── R/                            # 模組化 R 程式碼
├── output/                       # 圖表與報表輸出
├── docs/                         # 專案說明與進度紀錄
└── aging_medical_real_estate.Rproj # RStudio 專案檔

---

二、檔案命名原則（英文命名 + 類型 + 年月）

1. **不動產交易資料**
   - 放置於 `data/lvr_landcsv114Q3/`
   - 原始檔案可保留原始命名（如 a_lvr_land_a.csv）

2. **行政區人口指標**
   - 放置於 `data/population_index/`
   - 建議命名為：`aging_index_YYYYMM.csv`
   - 例如：`aging_index_202312.csv`

3. **特約健保單位資料**
   - 放置於 `data/medical_facilities/`
   - 命名格式：`[facility_type]_[YYYYMM].csv`
   - 例如：
     - `clinic_202510.csv`
     - `medical_center_202510.csv`
     - `hospital_local_202510.csv`
     - `hospital_regional_202510.csv`
     - `pharmacy_202510.csv`

4. **門牌座標資料**
   - 放置於 `data/geo/`
   - 命名格式：`[region]_address_coordinates_[YYYYMM].csv`
   - 例如：
     - `taipei_address_coordinates_202510.csv`
     - `hsinchu_city_address_coordinates_202510.csv`
     - `hsinchu_county_address_coordinates_202510.csv`

---

三、命名注意事項

✅ 使用英文檔名，避免中文亂碼或跨平台錯誤  
✅ 加入年月標記（YYYYMM）以利版本管理與自動化讀取  
✅ 地區名稱統一使用英文拼音（如 taipei、hsinchu_city）  
✅ 所有檔案請放入對應資料夾，勿混放在根目錄  

---

四、建議搭配工具

- 使用 `here::here()` 搭配相對路徑讀取資料
- 使用 `readr::read_csv()` 讀取大型 CSV 檔案
- 使用 `leaflet` 或 `ggplot2` 進行地圖視覺化

---

📌 如需更新資料來源與欄位說明，請同步更新 `docs/data_sources.md`
📌 如需新增資料夾，請先確認命名規則與結構一致性