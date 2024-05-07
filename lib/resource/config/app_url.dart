import 'dart:io';

class AppUrl {
  // static var domainName = Platform.isAndroid ? 'http://10.0.2.2:8000' : 'http://127.0.0.1:8000';
  static var domainName = 'https://kuuwaa.com';
  static var baseUrl = "$domainName/api";

  // AUTH
  static var loginEndPoint = '$baseUrl/login';
  static var otpVerificationEndPoint = '$baseUrl/otps/verification';
  static var userEndPoint = '$baseUrl/users';

  // EVENTS
  static var eventEndPoint = '$baseUrl/events';
  static var categoryEndPoint = '$baseUrl/event_categories';
  static var packEndPoint = '$baseUrl/event_packs';
  static var featureEndPoint = '$baseUrl/features';
  static var invitationEndPoint = '$baseUrl/invitations'; 
  static var tableEndPoint = '$baseUrl/tables';
  static var beverageEndPoint = '$baseUrl/beverages';
  static var eventAdminEndPoint = '$baseUrl/event-admins';
  static var booksEndPoint = '$baseUrl/books';
}