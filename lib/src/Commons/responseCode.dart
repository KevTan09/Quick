class ResponseCode {
  // Success
  static final String login_success = "CP201";
  static final String register_success = "CP202";
  static final String group_created = "CP203";
  static final String member_added = "CP204";

  static final String task_created = "CP205";
  static final String task_found = "CP206";
  static final String task_submitted = "CP207";

  static final String groups_found = "CP208";
  static final String member_found = "CP209";

  // Error
  static final String wrong_method = "CP400";

  static final String login_failed = "CP401";

  static final String email_used = "CP402";
  static final String username_used = "CP403";
  static final String register_failed = "CP404";

  static final String failed_create_group = "CP405";
  static final String user_not_found = "CP406";
  static final String member_existed = "CP407";
  static final String failed_to_add_member = "CP408";

  static final String unauthorized_user = "CP409";

  static final String failed_create_task = "CP410";
  static final String task_not_found = "CP411";
  static final String failed_submit_task = "CP412";
  static final String task_had_due = "CP413";

  static final String upload_file_error = "CP414";

  static final String groups_not_found = "CP415";
  static final String member_not_found = "CP416";
}