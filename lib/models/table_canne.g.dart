// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_canne.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTableCanneCollection on Isar {
  IsarCollection<TableCanne> get tableCannes => this.collection();
}

const TableCanneSchema = CollectionSchema(
  name: r'TableCanne',
  id: -1883647896565034202,
  properties: {
    r'anneeTableCanne': PropertySchema(
      id: 0,
      name: r'anneeTableCanne',
      type: IsarType.long,
    ),
    r'dateDecharg': PropertySchema(
      id: 1,
      name: r'dateDecharg',
      type: IsarType.dateTime,
    ),
    r'etatModification': PropertySchema(
      id: 2,
      name: r'etatModification',
      type: IsarType.bool,
    ),
    r'etatSynchronisation': PropertySchema(
      id: 3,
      name: r'etatSynchronisation',
      type: IsarType.bool,
    ),
    r'heureDecharg': PropertySchema(
      id: 4,
      name: r'heureDecharg',
      type: IsarType.long,
    ),
    r'tonnageTasDeverse': PropertySchema(
      id: 5,
      name: r'tonnageTasDeverse',
      type: IsarType.double,
    )
  },
  estimateSize: _tableCanneEstimateSize,
  serialize: _tableCanneSerialize,
  deserialize: _tableCanneDeserialize,
  deserializeProp: _tableCanneDeserializeProp,
  idName: r'id',
  indexes: {
    r'tonnageTasDeverse': IndexSchema(
      id: -5928373949372720834,
      name: r'tonnageTasDeverse',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'tonnageTasDeverse',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'anneeTableCanne': IndexSchema(
      id: 5233420128977536778,
      name: r'anneeTableCanne',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'anneeTableCanne',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'dateDecharg': IndexSchema(
      id: 6229229240779608041,
      name: r'dateDecharg',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'dateDecharg',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'heureDecharg': IndexSchema(
      id: -1546057536546981274,
      name: r'heureDecharg',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'heureDecharg',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _tableCanneGetId,
  getLinks: _tableCanneGetLinks,
  attach: _tableCanneAttach,
  version: '3.1.0+1',
);

int _tableCanneEstimateSize(
  TableCanne object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _tableCanneSerialize(
  TableCanne object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.anneeTableCanne);
  writer.writeDateTime(offsets[1], object.dateDecharg);
  writer.writeBool(offsets[2], object.etatModification);
  writer.writeBool(offsets[3], object.etatSynchronisation);
  writer.writeLong(offsets[4], object.heureDecharg);
  writer.writeDouble(offsets[5], object.tonnageTasDeverse);
}

TableCanne _tableCanneDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TableCanne();
  object.anneeTableCanne = reader.readLong(offsets[0]);
  object.dateDecharg = reader.readDateTime(offsets[1]);
  object.etatModification = reader.readBool(offsets[2]);
  object.etatSynchronisation = reader.readBool(offsets[3]);
  object.heureDecharg = reader.readLong(offsets[4]);
  object.id = id;
  object.tonnageTasDeverse = reader.readDouble(offsets[5]);
  return object;
}

P _tableCanneDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _tableCanneGetId(TableCanne object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _tableCanneGetLinks(TableCanne object) {
  return [];
}

void _tableCanneAttach(IsarCollection<dynamic> col, Id id, TableCanne object) {
  object.id = id;
}

extension TableCanneQueryWhereSort
    on QueryBuilder<TableCanne, TableCanne, QWhere> {
  QueryBuilder<TableCanne, TableCanne, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterWhere> anyTonnageTasDeverse() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'tonnageTasDeverse'),
      );
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterWhere> anyAnneeTableCanne() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'anneeTableCanne'),
      );
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterWhere> anyDateDecharg() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dateDecharg'),
      );
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterWhere> anyHeureDecharg() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'heureDecharg'),
      );
    });
  }
}

extension TableCanneQueryWhere
    on QueryBuilder<TableCanne, TableCanne, QWhereClause> {
  QueryBuilder<TableCanne, TableCanne, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterWhereClause>
      tonnageTasDeverseEqualTo(double tonnageTasDeverse) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'tonnageTasDeverse',
        value: [tonnageTasDeverse],
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterWhereClause>
      tonnageTasDeverseNotEqualTo(double tonnageTasDeverse) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tonnageTasDeverse',
              lower: [],
              upper: [tonnageTasDeverse],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tonnageTasDeverse',
              lower: [tonnageTasDeverse],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tonnageTasDeverse',
              lower: [tonnageTasDeverse],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tonnageTasDeverse',
              lower: [],
              upper: [tonnageTasDeverse],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterWhereClause>
      tonnageTasDeverseGreaterThan(
    double tonnageTasDeverse, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tonnageTasDeverse',
        lower: [tonnageTasDeverse],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterWhereClause>
      tonnageTasDeverseLessThan(
    double tonnageTasDeverse, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tonnageTasDeverse',
        lower: [],
        upper: [tonnageTasDeverse],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterWhereClause>
      tonnageTasDeverseBetween(
    double lowerTonnageTasDeverse,
    double upperTonnageTasDeverse, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tonnageTasDeverse',
        lower: [lowerTonnageTasDeverse],
        includeLower: includeLower,
        upper: [upperTonnageTasDeverse],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterWhereClause>
      anneeTableCanneEqualTo(int anneeTableCanne) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'anneeTableCanne',
        value: [anneeTableCanne],
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterWhereClause>
      anneeTableCanneNotEqualTo(int anneeTableCanne) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'anneeTableCanne',
              lower: [],
              upper: [anneeTableCanne],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'anneeTableCanne',
              lower: [anneeTableCanne],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'anneeTableCanne',
              lower: [anneeTableCanne],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'anneeTableCanne',
              lower: [],
              upper: [anneeTableCanne],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterWhereClause>
      anneeTableCanneGreaterThan(
    int anneeTableCanne, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'anneeTableCanne',
        lower: [anneeTableCanne],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterWhereClause>
      anneeTableCanneLessThan(
    int anneeTableCanne, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'anneeTableCanne',
        lower: [],
        upper: [anneeTableCanne],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterWhereClause>
      anneeTableCanneBetween(
    int lowerAnneeTableCanne,
    int upperAnneeTableCanne, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'anneeTableCanne',
        lower: [lowerAnneeTableCanne],
        includeLower: includeLower,
        upper: [upperAnneeTableCanne],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterWhereClause> dateDechargEqualTo(
      DateTime dateDecharg) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'dateDecharg',
        value: [dateDecharg],
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterWhereClause> dateDechargNotEqualTo(
      DateTime dateDecharg) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateDecharg',
              lower: [],
              upper: [dateDecharg],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateDecharg',
              lower: [dateDecharg],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateDecharg',
              lower: [dateDecharg],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateDecharg',
              lower: [],
              upper: [dateDecharg],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterWhereClause>
      dateDechargGreaterThan(
    DateTime dateDecharg, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateDecharg',
        lower: [dateDecharg],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterWhereClause> dateDechargLessThan(
    DateTime dateDecharg, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateDecharg',
        lower: [],
        upper: [dateDecharg],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterWhereClause> dateDechargBetween(
    DateTime lowerDateDecharg,
    DateTime upperDateDecharg, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateDecharg',
        lower: [lowerDateDecharg],
        includeLower: includeLower,
        upper: [upperDateDecharg],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterWhereClause> heureDechargEqualTo(
      int heureDecharg) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'heureDecharg',
        value: [heureDecharg],
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterWhereClause>
      heureDechargNotEqualTo(int heureDecharg) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'heureDecharg',
              lower: [],
              upper: [heureDecharg],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'heureDecharg',
              lower: [heureDecharg],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'heureDecharg',
              lower: [heureDecharg],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'heureDecharg',
              lower: [],
              upper: [heureDecharg],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterWhereClause>
      heureDechargGreaterThan(
    int heureDecharg, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'heureDecharg',
        lower: [heureDecharg],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterWhereClause> heureDechargLessThan(
    int heureDecharg, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'heureDecharg',
        lower: [],
        upper: [heureDecharg],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterWhereClause> heureDechargBetween(
    int lowerHeureDecharg,
    int upperHeureDecharg, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'heureDecharg',
        lower: [lowerHeureDecharg],
        includeLower: includeLower,
        upper: [upperHeureDecharg],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TableCanneQueryFilter
    on QueryBuilder<TableCanne, TableCanne, QFilterCondition> {
  QueryBuilder<TableCanne, TableCanne, QAfterFilterCondition>
      anneeTableCanneEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'anneeTableCanne',
        value: value,
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterFilterCondition>
      anneeTableCanneGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'anneeTableCanne',
        value: value,
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterFilterCondition>
      anneeTableCanneLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'anneeTableCanne',
        value: value,
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterFilterCondition>
      anneeTableCanneBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'anneeTableCanne',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterFilterCondition>
      dateDechargEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateDecharg',
        value: value,
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterFilterCondition>
      dateDechargGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateDecharg',
        value: value,
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterFilterCondition>
      dateDechargLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateDecharg',
        value: value,
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterFilterCondition>
      dateDechargBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateDecharg',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterFilterCondition>
      etatModificationEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'etatModification',
        value: value,
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterFilterCondition>
      etatSynchronisationEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'etatSynchronisation',
        value: value,
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterFilterCondition>
      heureDechargEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'heureDecharg',
        value: value,
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterFilterCondition>
      heureDechargGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'heureDecharg',
        value: value,
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterFilterCondition>
      heureDechargLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'heureDecharg',
        value: value,
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterFilterCondition>
      heureDechargBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'heureDecharg',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterFilterCondition>
      tonnageTasDeverseEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tonnageTasDeverse',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterFilterCondition>
      tonnageTasDeverseGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tonnageTasDeverse',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterFilterCondition>
      tonnageTasDeverseLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tonnageTasDeverse',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterFilterCondition>
      tonnageTasDeverseBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tonnageTasDeverse',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension TableCanneQueryObject
    on QueryBuilder<TableCanne, TableCanne, QFilterCondition> {}

extension TableCanneQueryLinks
    on QueryBuilder<TableCanne, TableCanne, QFilterCondition> {}

extension TableCanneQuerySortBy
    on QueryBuilder<TableCanne, TableCanne, QSortBy> {
  QueryBuilder<TableCanne, TableCanne, QAfterSortBy> sortByAnneeTableCanne() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'anneeTableCanne', Sort.asc);
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterSortBy>
      sortByAnneeTableCanneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'anneeTableCanne', Sort.desc);
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterSortBy> sortByDateDecharg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateDecharg', Sort.asc);
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterSortBy> sortByDateDechargDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateDecharg', Sort.desc);
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterSortBy> sortByEtatModification() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatModification', Sort.asc);
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterSortBy>
      sortByEtatModificationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatModification', Sort.desc);
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterSortBy>
      sortByEtatSynchronisation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatSynchronisation', Sort.asc);
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterSortBy>
      sortByEtatSynchronisationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatSynchronisation', Sort.desc);
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterSortBy> sortByHeureDecharg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heureDecharg', Sort.asc);
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterSortBy> sortByHeureDechargDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heureDecharg', Sort.desc);
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterSortBy> sortByTonnageTasDeverse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tonnageTasDeverse', Sort.asc);
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterSortBy>
      sortByTonnageTasDeverseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tonnageTasDeverse', Sort.desc);
    });
  }
}

extension TableCanneQuerySortThenBy
    on QueryBuilder<TableCanne, TableCanne, QSortThenBy> {
  QueryBuilder<TableCanne, TableCanne, QAfterSortBy> thenByAnneeTableCanne() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'anneeTableCanne', Sort.asc);
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterSortBy>
      thenByAnneeTableCanneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'anneeTableCanne', Sort.desc);
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterSortBy> thenByDateDecharg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateDecharg', Sort.asc);
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterSortBy> thenByDateDechargDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateDecharg', Sort.desc);
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterSortBy> thenByEtatModification() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatModification', Sort.asc);
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterSortBy>
      thenByEtatModificationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatModification', Sort.desc);
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterSortBy>
      thenByEtatSynchronisation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatSynchronisation', Sort.asc);
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterSortBy>
      thenByEtatSynchronisationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatSynchronisation', Sort.desc);
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterSortBy> thenByHeureDecharg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heureDecharg', Sort.asc);
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterSortBy> thenByHeureDechargDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heureDecharg', Sort.desc);
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterSortBy> thenByTonnageTasDeverse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tonnageTasDeverse', Sort.asc);
    });
  }

  QueryBuilder<TableCanne, TableCanne, QAfterSortBy>
      thenByTonnageTasDeverseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tonnageTasDeverse', Sort.desc);
    });
  }
}

extension TableCanneQueryWhereDistinct
    on QueryBuilder<TableCanne, TableCanne, QDistinct> {
  QueryBuilder<TableCanne, TableCanne, QDistinct> distinctByAnneeTableCanne() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'anneeTableCanne');
    });
  }

  QueryBuilder<TableCanne, TableCanne, QDistinct> distinctByDateDecharg() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateDecharg');
    });
  }

  QueryBuilder<TableCanne, TableCanne, QDistinct> distinctByEtatModification() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'etatModification');
    });
  }

  QueryBuilder<TableCanne, TableCanne, QDistinct>
      distinctByEtatSynchronisation() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'etatSynchronisation');
    });
  }

  QueryBuilder<TableCanne, TableCanne, QDistinct> distinctByHeureDecharg() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'heureDecharg');
    });
  }

  QueryBuilder<TableCanne, TableCanne, QDistinct>
      distinctByTonnageTasDeverse() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tonnageTasDeverse');
    });
  }
}

extension TableCanneQueryProperty
    on QueryBuilder<TableCanne, TableCanne, QQueryProperty> {
  QueryBuilder<TableCanne, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TableCanne, int, QQueryOperations> anneeTableCanneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'anneeTableCanne');
    });
  }

  QueryBuilder<TableCanne, DateTime, QQueryOperations> dateDechargProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateDecharg');
    });
  }

  QueryBuilder<TableCanne, bool, QQueryOperations> etatModificationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'etatModification');
    });
  }

  QueryBuilder<TableCanne, bool, QQueryOperations>
      etatSynchronisationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'etatSynchronisation');
    });
  }

  QueryBuilder<TableCanne, int, QQueryOperations> heureDechargProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'heureDecharg');
    });
  }

  QueryBuilder<TableCanne, double, QQueryOperations>
      tonnageTasDeverseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tonnageTasDeverse');
    });
  }
}
