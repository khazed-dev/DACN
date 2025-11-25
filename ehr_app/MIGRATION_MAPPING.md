# BẢNG MAPPING CHI TIẾT - MIGRATION SANG CẤU TRÚC MỚI

## I. MODELS
| File Hiện Tại | Vị Trí Mới | Ghi Chú | Import Cần Chỉnh |
|---|---|---|---|
| modules/prescriptions/models/prescription_model.dart | lib/models/prescription_model.dart | Copy không đổi tên | Chỉnh import MedicalDrug |
| modules/prescriptions/models/medical_drug.dart | lib/models/medical_drug.dart | Copy không đổi tên | Không có |
| modules/health_notes/models/health_notes_model.dart | lib/models/health_notes_model.dart | Copy không đổi tên | Chỉnh import Timestamp |
| modules/treatment_plan/models/treatment_plan.dart | lib/models/treatment_plan_model.dart | **Rename** (thêm _model) | Chỉnh import Timestamp |

## II. SERVICES
| File Hiện Tại | Vị Trí Mới | Ghi Chú | Import Cần Chỉnh |
|---|---|---|---|
| modules/prescriptions/services/prescription_service.dart | lib/services/prescription_service.dart | Copy không đổi tên | Chỉnh import model: `../models/prescription_model.dart` |
| modules/health_notes/services/health_notes_service.dart | lib/services/health_notes_service.dart | Copy không đổi tên | Chỉnh import model: `../models/health_notes_model.dart` |
| modules/treatment_plan/services/treatment_plan_service.dart | lib/services/treatment_plan_service.dart | Copy không đổi tên | Chỉnh import model: `../models/treatment_plan_model.dart` |
| lib/services/user_profile_service.dart | GIỮ NGUYÊN | Đã ở vị trí đúng | Không có |

## III. SCREENS

### A. AUTH SCREENS
| File Hiện Tại | Vị Trí Mới | Ghi Chú | Import Cần Chỉnh |
|---|---|---|---|
| modules/auth/screens/auth_gate.dart | lib/screens/auth/auth_gate.dart | Copy | Chỉnh imports path |
| modules/auth/screens/login_screen.dart | lib/screens/auth/login_screen.dart | Move + Copy | Chỉnh imports |

### B. PATIENT SCREENS
| File Hiện Tại | Vị Trí Mới | Ghi Chú | Import Cần Chỉnh |
|---|---|---|---|
| modules/patient/screens/patient_home_screen.dart | lib/screens/patient/patient_home_screen.dart | Copy | Chỉnh imports các module screens |
| modules/patient/screens/patient_details_screen.dart | lib/screens/patient/patient_details_screen.dart | Copy | Chỉnh imports |
| modules/health_notes/screens/health_notes_screen.dart | lib/screens/patient/health_notes_screen.dart | Move | Chỉnh imports |
| modules/health_notes/screens/edit_health_notes_screen.dart | lib/screens/patient/edit_health_notes_screen.dart | Move | Chỉnh imports |
| modules/treatment_plan/screens/patient_treatment_plan_list_screen.dart | lib/screens/patient/patient_treatment_plan_list_screen.dart | Move | Chỉnh imports |
| modules/prescriptions/screens/patient_prescription_list_screen.dart | lib/screens/patient/patient_prescription_list_screen.dart | Move | Chỉnh imports |

### C. DOCTOR SCREENS
| File Hiện Tại | Vị Trí Mới | Ghi Chú | Import Cần Chỉnh |
|---|---|---|---|
| modules/doctor/screens/doctor_home_screen.dart | lib/screens/doctor/doctor_home_screen.dart | Copy | Chỉnh imports |
| modules/doctor/screens/doctor_patient_details_screen.dart | lib/screens/doctor/doctor_patient_details_screen.dart | Copy | Chỉnh imports |
| modules/doctor/screens/doctor_patient_list_screen.dart | lib/screens/doctor/doctor_patient_list_screen.dart | Copy | Chỉnh imports |
| modules/treatment_plan/screens/treatment_plan_list_screen.dart | lib/screens/doctor/treatment_plan_list_screen.dart | Move | Chỉnh imports |
| modules/treatment_plan/screens/create_treatment_plan_screen.dart | lib/screens/doctor/create_treatment_plan_screen.dart | Move | Chỉnh imports |
| modules/treatment_plan/screens/treatment_plan_detail_screen.dart | lib/screens/doctor/treatment_plan_detail_screen.dart | Move | Chỉnh imports |
| modules/prescriptions/screens/doctor_prescription_list_screen.dart | lib/screens/doctor/doctor_prescription_list_screen.dart | Move | Chỉnh imports |
| modules/prescriptions/screens/create_prescription_screen.dart | lib/screens/doctor/create_prescription_screen.dart | Move | Chỉnh imports |
| modules/prescriptions/screens/edit_prescription_screen.dart | lib/screens/doctor/edit_prescription_screen.dart | Move | Chỉnh imports |
| modules/prescriptions/screens/doctor_prescription_detail_screen.dart | lib/screens/doctor/doctor_prescription_detail_screen.dart | Move | Chỉnh imports |

### D. COMMON SCREENS (Dùng chung)
| File Hiện Tại | Vị Trí Mới | Ghi Chú | Import Cần Chỉnh |
|---|---|---|---|
| modules/prescriptions/screens/prescription_detail_screen.dart | lib/screens/common/prescription_detail_screen.dart | Move | Chỉnh imports |
| modules/prescriptions/screens/prescription_list_screen.dart | lib/screens/common/prescription_list_screen.dart | Move | Chỉnh imports |
| modules/prescriptions/screens/prescription_qr_screen.dart | lib/screens/common/prescription_qr_screen.dart | Move | Chỉnh imports |

### E. PHARMACY SCREENS
| File Hiện Tại | Vị Trí Mới | Ghi Chú | Import Cần Chỉnh |
|---|---|---|---|
| modules/pharmacy/screens/pharmacy_home_screen.dart | lib/screens/pharmacy/pharmacy_home_screen.dart | Copy (tạo mới) | Chỉnh imports |
| modules/pharmacy/screens/pharmacy_scan_screen.dart | lib/screens/pharmacy/pharmacy_scan_screen.dart | Copy (tạo mới) | Chỉnh imports |
| modules/pharmacy/screens/pharmacy_verify_screen.dart | lib/screens/pharmacy/pharmacy_verify_screen.dart | Copy (tạo mới) | Chỉnh imports |
| modules/pharmacy/screens/pharmacy_history_screen.dart | lib/screens/pharmacy/pharmacy_history_screen.dart | Copy (tạo mới) | Chỉnh imports |
| modules/prescriptions/screens/pharmacy_confirm_screen.dart | lib/screens/pharmacy/pharmacy_confirm_screen.dart | Move | Chỉnh imports |
| modules/prescriptions/screens/pharmacy_scan_screen.dart | lib/screens/pharmacy/pharmacy_scan_screen_prescription.dart | Move + **Rename** | Chỉnh imports (conflict?) |

## IV. WIDGETS
| File Hiện Tại | Vị Trí Mới | Ghi Chú | Import Cần Chỉnh |
|---|---|---|---|
| modules/doctor/widgets/* | lib/widgets/ | Copy + merge | Chỉnh imports |
| modules/patient/widgets/* | lib/widgets/ | Copy + merge | Chỉnh imports |
| modules/pharmacy/widgets/* | lib/widgets/ | Copy + merge | Chỉnh imports |

## V. PROVIDERS
| File Hiện Tại | Vị Trí Mới | Ghi Chú | Import Cần Chỉnh |
|---|---|---|---|
| modules/auth/providers/* | lib/providers/ | Copy (nếu có) | Chỉnh imports |

---

## ĐẶC BIỆT LƯU Ý:
1. **prescription_service.dart**: Cần đọc file để hiểu imports - có import từ modules/prescriptions/models/**
2. **treatment_plan_service.dart**: Check import TreatmentPlan model
3. **Conflict kiến trúc**: 
   - `prescription_detail_screen.dart` ở 2 chỗ: modules/prescriptions/ + modules/pharmacy/
   - `pharmacy_scan_screen.dart` ở 2 chỗ: modules/pharmacy/ + modules/prescriptions/
   → Cần xác nhận logic khác biệt

