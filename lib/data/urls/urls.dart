class Urls{
  static const String _baseUrl = 'http://35.73.30.144:2005/api/v1';

  static const String registrationUrl = '$_baseUrl/Registration';

  static const String signInUrl = '$_baseUrl/Login';

  static const String createNewTaskUrl = '$_baseUrl/createTask';

  static const String newTaskUrl = '$_baseUrl/listTaskByStatus/New';

  static const String progressTaskUrl = '$_baseUrl/listTaskByStatus/Progress';

  static const String completedTaskUrl = '$_baseUrl/listTaskByStatus/Completed';

  static const String cancelledTaskUrl = '$_baseUrl/listTaskByStatus/Cancelled';

  static const String taskCountListUrl = '$_baseUrl/taskStatusCount';

  static const String updateProfileUrl = '$_baseUrl/ProfileUpdate';

  static const String recoverResetPassUrl = '$_baseUrl/RecoverResetPassword';



  static String changeTaskStatusUrl(String taskId, String status) => '$_baseUrl/updateTaskStatus/$taskId/$status';

  static String deleteTaskUrl(String taskId) => '$_baseUrl/deleteTask/$taskId';

  static String recoverVerifyEmailUrl(String email) => '$_baseUrl/RecoverVerifyEmail/$email';

  static String recoverVerifyOtpUrl(String email, String otp) => '$_baseUrl/RecoverVerifyOtp/$email/$otp';


}