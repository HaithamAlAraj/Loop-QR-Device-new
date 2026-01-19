import 'package:qr_device/constants/queries/get_stamps.dart';
import 'package:qr_device/helpers/mappers/stamp_mapper.dart';

import '../constants/store_data.dart';
import '../models/stamp.dart';
import 'graphql_http_client.dart';

class ApiService {
  ApiService(this._gql);
  final GraphqlHttpClient _gql;

  // -------- STAMPS --------
  Future<List<Stamp>> fetchStamps() async {
    final data = await _gql.post(
      query: qGetStampsByStore,
      variables: {
        'shop_id': StoreData.storeId,
        'first': 100,
      },
    );
    return QrStampMapper.listFromGraphqlData(data);
  }
}