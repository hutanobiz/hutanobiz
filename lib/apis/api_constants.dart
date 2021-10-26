const apiRegister = 'register';
const String apiLogin = "auth/api/login";

const String apiSetupIntent = "api/stripe-setUp-intent";
// const String kstripePublishKey = 'pk_test_LlxS6SLz0PrOm9IY9mxM0LHo006tjnSqWX';
const String kstripePublishKey = 'pk_live_zS0abZnamyBWOHpaC4PxgF7X0097JjrYiQ';
const String apiEmailVerification = "api/email-verification";
const String apiResetPassword = "reset-password";
const String apiResetPasswordNew = "reset-password-new";
const String apiLoginPin = "pin-login";
const String apiResetPin = "reset-pin";
const String apiOtpOnCall = "otp-on-call";
const String apiSearchContact = "search-contacts";
const String apiUserRelations = "user-relations";
const String apiAddMember = "add-family-members";
const String apiAddPermission = "manage-family-member-permission/";
const String apiCheckEmailExist = "check-user";
const String apiSendInvitaion = "api/patient/send-invitation";
const String apiGenerateCardToken = "https://api.stripe.com/v1/tokens";
const String apiCreatePin = "api/create-pin";
const String apiAddCard = "api/add-card";
const String apiGetCard = "api/stripe-card";
const String apiGetPatientInsurance = "get-patient-insurance";
const String success = "success";
const String apiGetProviders = "get-providers";
const String apiGetProvidersGroups = "get-provider-groups";
const String apiAddProviders = "add-edit-providers";
const String apiMyProviderNetwork = "get-all-providers";
const String apiRemoveProvider = "delete-providers";
const String apiShareProvider = "share-single-user";
const String apiShareMessage = "send-single-user";
const String apiGetStates = "states";
const String apiGetInsurance = "insurance";
const String apiVerifyAddress = "verify-address";
const String apiGetFamilyNetwork = "get-family-members";
const String apiUserPermission = "user-permission";
const String apiSymptoms = "api/patient/get-pain-symptoms";
const String apiCreateAppoinment = "api/patient/create-appointment";
const String apiMedicineList = "api/patient/medicine-list";
const String apiAppointmentList = "appointment-list";
const String apiShareAllProvider = "share-all-providers";
const String apiDisease = "api/disease";
const String apiUploadDocuments = "api/patient/upload-documents";
const String apiDocumentList = "api/patient/documents-list";
const String apiImages = "upload-documents";
const String apiRemoveMedicalImages = "remove-medical-images";
const String apiCustomerCharge = "customer-charge";
const String apiAddInsurance = "add-my-insurance";
const String apiUploadInsuranceImage = "upload-insurance-documents";
const String apiAddInsuranceDoc = "add-patient-insurance";
const String apiMyInsurance = "my-insurance";
const String apiGetInviteMessage = "get-invitation-message";
const String apiGetProviderPackages = "get-provider-packages";
const String apiRewardPoints = "reward-points";
const String apiInviteMember = "invite-member";
const String apiOfficeAppointmentStatus = "office-appointment-tracking-details";
const String apiOnSiteAppointmentStatus = "doctor-appointment-details";

const String googlePlaceSuggetion = "textsearch/json";
const String googlePlaceDetail = "details/json";
const String googleAddressSuggetion = "autocomplete/json";
const String getNewDiseaseEndPoint = "api/disease";
const String getMyDiseaseEndPoint = "api/patient/medical-images-documents";
const String addPatientDiseaseEndPoint = "api/patient/medical-history";
const String getCommunicationReasonEndPoint =
    "api/patient/communication-reason";
const String addCommunicationReasonEndPoint =
    "api/patient/communication-problem";
const String addPharmacyEndPoint = "api/patient/add-pharmacy";
const String addVitalsEndPoint = "api/patient/add-vitals-recently";
const String addDiagnosticsPoint = "api/patient/add-diagnostic-data";
const String addTreatedConditionTimePoint =
    "api/patient/treated-condition-time";
const String notificationEndPoint = "api/patient/notification-list";
const String notificationReadEndPoint = "api/patient/notification-read";
const String getPatientUploadedDocumentsImagesEndPoint =
    "api/patient/medical-images-documents";
const String currentMedicalHistoryEndPoint = "api/patient/add-medical-detail";
const String getDiagnosticTestEndPoint = "api/patient/diagnostic-test-results";
const String getBodyPartEndPoint = "api/patient/get-body-part";
const String addMedicationDetailEndPoint = "api/patient/medications";
const String apiRemoveFamilyNetwork = "remove-family-network";
const String getMedicationDetailEndPoint = "api/patient/medications";
const String getMoreConditionEndPoint = "api/patient/problem-list";
const String getHealthConditionDetailsEndPoint =
    "api/patient/selected-problem-list";
const String getDiagnosticTestFromApiEndPoint =
    "api/patient/dignoStics-test-type-list";
const String newBookingAppointmentFlowEndPoint =
    "api/patient/appointment-booking-v1";
const String onSiteAddressEndPoint = "api/patient/address";
const String updatePaymentMethodEndPoint = 'api/patient/appointment/update';
