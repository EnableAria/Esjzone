export 'decrypt_response.dart';
export 'favorite_response.dart';
export 'forum_response.dart';
export 'forum_row.dart';
export 'like_response.dart';
export 'login_response.dart';
export 'profile.dart';
export 'releases_response.dart';
export 'user_cookie.dart';
import 'package:quiver/core.dart';

T? checkOptional<T>(Optional<T?>? optional, T? Function()? def) {
  // No value given, just take default value
  if (optional == null) return def?.call();

  // We have an input value
  if (optional.isPresent) return optional.value;

  // We have a null inside the optional
  return null;
}
