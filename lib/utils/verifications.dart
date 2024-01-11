import 'package:quickdep/model/account/account_model.dart';

class Verifications {
  static emailNotVerified (AccountModel account) {
    return account.id != null && account.emailVerified != true;
  }

  static phoneNumberNotVerified (AccountModel account) {
    return account.id != null && account.phoneNumberVerified != true;
  }

  static contractNotSigned (AccountModel account) {
    return account.id != null &&
      !(
        account.contract != null
        && account.contract!.signed == true
      )
    ;
  }

  static enterpriseAccountNotValidated (AccountModel account) {
    return account.id != null && account.enterprise != null &&
      (
        !Verifications.emailNotVerified(account) &&
        !Verifications.phoneNumberNotVerified(account) &&
        !Verifications.contractNotSigned(account) &&
        account.enterprise!.validated != true
      )
    ;
  }
}
