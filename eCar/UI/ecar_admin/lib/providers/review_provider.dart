import 'package:ecar_admin/models/Review/review.dart';
import 'package:ecar_admin/providers/base_provider.dart';

class ReviewProvider extends BaseProvider<Review> {
  ReviewProvider() : super("Review");
  @override
  Review fromJson(data) {
    return Review.fromJson(data);
  }
}
