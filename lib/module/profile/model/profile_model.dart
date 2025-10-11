class ProfileModel {
  int? id;
  String? name;
  String? email;
  dynamic emailVerifiedAt;
  dynamic plan;
  dynamic planExpireDate;
  int? requestedPlan;
  int? trialPlan;
  dynamic trialExpireDate;
  String? type;
  int? storageLimit;
  String? avatar;
  String? messengerColor;
  dynamic lang;
  dynamic defaultPipeline;
  bool? activeStatus;
  int? deleteStatus;
  String? mode;
  bool? darkMode;
  int? isDisable;
  int? isEnableLogin;
  int? isActive;
  dynamic referralCode;
  dynamic usedReferralCode;
  int? commissionAmount;
  dynamic lastLoginAt;
  int? createdBy;
  dynamic rememberToken;
  bool? isEmailVerified;
  String? createdAt;
  String? updatedAt;

  ProfileModel({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.plan,
    this.planExpireDate,
    this.requestedPlan,
    this.trialPlan,
    this.trialExpireDate,
    this.type,
    this.storageLimit,
    this.avatar,
    this.messengerColor,
    this.lang,
    this.defaultPipeline,
    this.activeStatus,
    this.deleteStatus,
    this.mode,
    this.darkMode,
    this.isDisable,
    this.isEnableLogin,
    this.isActive,
    this.referralCode,
    this.usedReferralCode,
    this.commissionAmount,
    this.lastLoginAt,
    this.createdBy,
    this.rememberToken,
    this.isEmailVerified,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      plan: json['plan'],
      planExpireDate: json['plan_expire_date'],
      requestedPlan: json['requested_plan'],
      trialPlan: json['trial_plan'],
      trialExpireDate: json['trial_expire_date'],
      type: json['type'],
      storageLimit: json['storage_limit'],
      avatar: json['avatar'],
      messengerColor: json['messenger_color'],
      lang: json['lang'],
      defaultPipeline: json['default_pipeline'],
      activeStatus: json['active_status'],
      deleteStatus: json['delete_status'],
      mode: json['mode'],
      darkMode: json['dark_mode'],
      isDisable: json['is_disable'],
      isEnableLogin: json['is_enable_login'],
      isActive: json['is_active'],
      referralCode: json['referral_code'],
      usedReferralCode: json['used_referral_code'],
      commissionAmount: json['commission_amount'],
      lastLoginAt: json['last_login_at'],
      createdBy: json['created_by'],
      rememberToken: json['remember_token'],
      isEmailVerified: json['is_email_verified'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "plan": plan,
        "plan_expire_date": planExpireDate,
        "requested_plan": requestedPlan,
        "trial_plan": trialPlan,
        "trial_expire_date": trialExpireDate,
        "type": type,
        "storage_limit": storageLimit,
        "avatar": avatar,
        "messenger_color": messengerColor,
        "lang": lang,
        "default_pipeline": defaultPipeline,
        "active_status": activeStatus,
        "delete_status": deleteStatus,
        "mode": mode,
        "dark_mode": darkMode,
        "is_disable": isDisable,
        "is_enable_login": isEnableLogin,
        "is_active": isActive,
        "referral_code": referralCode,
        "used_referral_code": usedReferralCode,
        "commission_amount": commissionAmount,
        "last_login_at": lastLoginAt,
        "created_by": createdBy,
        "remember_token": rememberToken,
        "is_email_verified": isEmailVerified,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
