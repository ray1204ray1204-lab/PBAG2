# ----------------------------------------------------------------------
# 專案：醫療密度、人口老化與不動產資料推估模型
#
# 腳本：medical_facilitate.R (完整合併版)
#
# 階段 (一)：載入資料
# 階段 (二)：依「鄉鎮市區」統計
# 階段 (三)：分離「關鍵醫院」與「基層醫療」
# ----------------------------------------------------------------------

# 1. 載入所需套件
# (如果尚未安裝，請先執行 install.packages("tidyverse"))
library(readr)     
library(dplyr)     
library(stringr)   
library(ggplot2)   

# ----------------------------------------------------------------------
# 2. 載入並整合資料 (使用相對路徑)
# ----------------------------------------------------------------------

# 檔案路徑 (從 .Rproj 所在的 "PBAG2/" 根目錄出發)
file_medical_center <- "data/medical_facilities/medical_center_202510.csv"
file_regional <- "data/medical_facilities/hospital_regional_202510.csv"
file_local <- "data/medical_facilities/hospital_local_202510.csv"
file_clinic <- "data/medical_facilities/clinic_202510.csv"
file_pharmacy <- "data/medical_facilities/pharmacy_202510.csv"

# 函數：安全讀取 CSV 並加上層級標籤
safe_read_csv <- function(file_path, level_name) {
  read_csv(
    file_path,
    col_types = cols(.default = "c") # 強制所有欄位為文字，避免警告
  ) %>%
    mutate(Level = level_name)
}

# 讀取並標記所有資料
df_medical_center <- safe_read_csv(file_medical_center, "醫學中心")
df_regional <- safe_read_csv(file_regional, "區域醫院")
df_local <- safe_read_csv(file_local, "地區醫院")
df_clinic <- safe_read_csv(file_clinic, "診所")
df_pharmacy <- safe_read_csv(file_pharmacy, "藥局")

# 整合為一個資料框
all_medical_data <- bind_rows(
  df_medical_center,
  df_regional,
  df_local,
  df_clinic,
  df_pharmacy
)

# 清理記憶體
rm(df_medical_center, df_regional, df_local, df_clinic, df_pharmacy)

# ----------------------------------------------------------------------
# 3. 資料處理：篩選並萃取「鄉鎮市區」
# ----------------------------------------------------------------------

target_regions <- c("新竹市", "新竹縣")

medical_summary_district <- all_medical_data %>%
  # 1. 篩選：只保留新竹縣市
  filter(
    str_detect(地址, "新竹市|新竹縣")
  ) %>%
  mutate(
    # 2. 建立 "Region" (縣市) 欄位
    Region = case_when(
      str_detect(地址, "新竹市") ~ "新竹市",
      str_detect(地址, "新竹縣") ~ "新竹縣",
      TRUE ~ NA_character_
    ),
    
    # 3. 萃取 "District" (鄉鎮市區) 欄位
    District = str_match(地址, "(新竹市|新竹縣)([^市區鄉鎮]+[市區鄉鎮])")[, 3],
    
    # 4. 建立 "Level" (層級) 因子
    Level = factor(Level, levels = c("醫學中心", "區域醫院", "地區醫院", "診所", "藥局")),
    Region = factor(Region, levels = target_regions)
  ) %>%
  # 5. 確保 "District" 都有成功萃取
  filter(!is.na(District)) %>%
  
  # 6. 依照新的維度分組：縣市、鄉鎮市區、層級
  group_by(Region, District, Level) %>%
  
  # 7. 統計數量
  summarise(Count = n(), .groups = 'drop') %>%
  
  # 8. 為了讓圖表排序好看，算出每個 District 的總數
  group_by(Region, District) %>% # 依 Region, District 分組
  mutate(DistrictTotal = sum(Count)) %>%
  ungroup()

# (可選) 顯示統計結果
# print(medical_summary_district, n = 30) 

# ----------------------------------------------------------------------
# 4.1 資料視覺化：關鍵醫院 (Hospital-Level)
# ----------------------------------------------------------------------

# 篩選出三種層級的醫院
data_hospitals <- medical_summary_district %>%
  filter(Level %in% c("醫學中心", "區域醫院", "地區醫院"))

# 繪製醫院分佈圖
plot_hospitals <- ggplot(
  data_hospitals, 
  # X 軸使用 -DistrictTotal 排序 (負號代表由大到小)
  aes(x = reorder(District, -DistrictTotal), y = Count, fill = Level)
) +
  geom_col(position = "stack") + 
  
  # 在長條圖上顯示數字
  geom_text(
    aes(label = Count), 
    position = position_stack(vjust = 0.5), 
    color = "white", 
    size = 3.5
  ) +
  
  facet_wrap(~ Region, scales = "free_x") +
  
  labs(
    title = "新竹縣市「關鍵醫院」分佈 (依鄉鎮市區)",
    subtitle = "醫學中心、區域醫院、地區醫院 (尺度：0-10)",
    x = "鄉鎮市區 (依總醫療單位排序)",
    y = "醫院數量",
    fill = "醫院層級"
  ) +
  theme_minimal(base_family = "sans") +
  theme(
    # (請替換成您可用的中文字型，例如 "PingFang TC" (Mac) 或 "Microsoft JhengHei" (Win))
    text = element_text(family = "Microsoft JhengHei"), 
    axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
    legend.position = "bottom"
  )

# 顯示圖表
print(plot_hospitals)

# (可選) 儲存圖表
ggsave("medical_distribution_Hsinchu_Hospitals.png", plot = plot_hospitals, width = 12, height = 7, dpi = 300)


# ----------------------------------------------------------------------
# 4.2 資料視覺化：基層醫療 (Clinic/Pharmacy-Level)
# ----------------------------------------------------------------------

# 篩選出診所與藥局
data_clinics_pharmacies <- medical_summary_district %>%
  filter(Level %in% c("診所", "藥局"))

# 繪製基層醫療分佈圖
plot_clinics_pharmacies <- ggplot(
  data_clinics_pharmacies, 
  aes(x = reorder(District, -DistrictTotal), y = Count, fill = Level)
) +
  geom_col() + # 堆疊長條圖
  
  facet_wrap(~ Region, scales = "free_x") +
  
  labs(
    title = "新竹縣市「基層醫療」分佈 (依鄉鎮市區)",
    subtitle = "診所與藥局 (尺度：0-1000+)",
    x = "鄉鎮市區 (依總醫療單位排序)",
    y = "單位數量",
    fill = "基層層級"
  ) +
  theme_minimal(base_family = "sans") +
  theme(
    text = element_text(family = "Microsoft JhengHei"), 
    axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
    legend.position = "bottom"
  )

# 顯示圖表
print(plot_clinics_pharmacies)

# (可選) 儲存圖表
ggsave("medical_distribution_Hsinchu_ClinicsPharmacies.png", plot = plot_clinics_pharmacies, width = 12, height = 7, dpi = 300)