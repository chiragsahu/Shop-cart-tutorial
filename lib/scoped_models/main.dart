import 'package:scoped_model/scoped_model.dart';
import 'package:test_prj/scoped_models/connected.dart';


class MainModel extends Model with connectedProductModel, UserModel, ProductModel, UtilityModel {}
