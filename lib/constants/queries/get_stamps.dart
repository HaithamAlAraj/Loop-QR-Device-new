const String qGetStampsByStore = r'''
query GetStampsByStore($shop_id: UUID!, $first: Int!) {
  stampsCollection(
    first: $first
    filter: { shop_id: { eq: $shop_id }, active: { eq: true } }
    orderBy: [{ created_at: DescNullsLast }]
  ) {
    edges {
      node {
        stamp_id
        shop_id
        name
        description
        stamps_required
        reward_type
      }
    }
  }
}
''';
