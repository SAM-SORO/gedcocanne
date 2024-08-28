// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ligne.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLigneCollection on Isar {
  IsarCollection<Ligne> get lignes => this.collection();
}

const LigneSchema = CollectionSchema(
  name: r'Ligne',
  id: 1006978662776648375,
  properties: {
    r'libele': PropertySchema(
      id: 0,
      name: r'libele',
      type: IsarType.string,
    ),
    r'nbreTas': PropertySchema(
      id: 1,
      name: r'nbreTas',
      type: IsarType.long,
    ),
    r'poidsTotal': PropertySchema(
      id: 2,
      name: r'poidsTotal',
      type: IsarType.double,
    ),
    r'tas': PropertySchema(
      id: 3,
      name: r'tas',
      type: IsarType.objectList,
      target: r'Tas',
    )
  },
  estimateSize: _ligneEstimateSize,
  serialize: _ligneSerialize,
  deserialize: _ligneDeserialize,
  deserializeProp: _ligneDeserializeProp,
  idName: r'id',
  indexes: {
    r'libele': IndexSchema(
      id: 690370265933472510,
      name: r'libele',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'libele',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'nbreTas': IndexSchema(
      id: -7937386375675483190,
      name: r'nbreTas',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'nbreTas',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {
    r'camions': LinkSchema(
      id: 8798726071226027583,
      name: r'camions',
      target: r'DechargerCours',
      single: false,
    ),
    r'agent': LinkSchema(
      id: 5901258413223317169,
      name: r'agent',
      target: r'Agent',
      single: true,
    )
  },
  embeddedSchemas: {r'Tas': TasSchema},
  getId: _ligneGetId,
  getLinks: _ligneGetLinks,
  attach: _ligneAttach,
  version: '3.1.0+1',
);

int _ligneEstimateSize(
  Ligne object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.libele.length * 3;
  bytesCount += 3 + object.tas.length * 3;
  {
    final offsets = allOffsets[Tas]!;
    for (var i = 0; i < object.tas.length; i++) {
      final value = object.tas[i];
      bytesCount += TasSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _ligneSerialize(
  Ligne object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.libele);
  writer.writeLong(offsets[1], object.nbreTas);
  writer.writeDouble(offsets[2], object.poidsTotal);
  writer.writeObjectList<Tas>(
    offsets[3],
    allOffsets,
    TasSchema.serialize,
    object.tas,
  );
}

Ligne _ligneDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Ligne(
    libele: reader.readString(offsets[0]),
  );
  object.id = id;
  object.nbreTas = reader.readLong(offsets[1]);
  object.poidsTotal = reader.readDouble(offsets[2]);
  object.tas = reader.readObjectList<Tas>(
        offsets[3],
        TasSchema.deserialize,
        allOffsets,
        Tas(),
      ) ??
      [];
  return object;
}

P _ligneDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readObjectList<Tas>(
            offset,
            TasSchema.deserialize,
            allOffsets,
            Tas(),
          ) ??
          []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _ligneGetId(Ligne object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _ligneGetLinks(Ligne object) {
  return [object.camions, object.agent];
}

void _ligneAttach(IsarCollection<dynamic> col, Id id, Ligne object) {
  object.id = id;
  object.camions
      .attach(col, col.isar.collection<DechargerCours>(), r'camions', id);
  object.agent.attach(col, col.isar.collection<Agent>(), r'agent', id);
}

extension LigneQueryWhereSort on QueryBuilder<Ligne, Ligne, QWhere> {
  QueryBuilder<Ligne, Ligne, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterWhere> anyNbreTas() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'nbreTas'),
      );
    });
  }
}

extension LigneQueryWhere on QueryBuilder<Ligne, Ligne, QWhereClause> {
  QueryBuilder<Ligne, Ligne, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Ligne, Ligne, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterWhereClause> idBetween(
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

  QueryBuilder<Ligne, Ligne, QAfterWhereClause> libeleEqualTo(String libele) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'libele',
        value: [libele],
      ));
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterWhereClause> libeleNotEqualTo(
      String libele) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'libele',
              lower: [],
              upper: [libele],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'libele',
              lower: [libele],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'libele',
              lower: [libele],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'libele',
              lower: [],
              upper: [libele],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterWhereClause> nbreTasEqualTo(int nbreTas) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'nbreTas',
        value: [nbreTas],
      ));
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterWhereClause> nbreTasNotEqualTo(int nbreTas) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nbreTas',
              lower: [],
              upper: [nbreTas],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nbreTas',
              lower: [nbreTas],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nbreTas',
              lower: [nbreTas],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nbreTas',
              lower: [],
              upper: [nbreTas],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterWhereClause> nbreTasGreaterThan(
    int nbreTas, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'nbreTas',
        lower: [nbreTas],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterWhereClause> nbreTasLessThan(
    int nbreTas, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'nbreTas',
        lower: [],
        upper: [nbreTas],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterWhereClause> nbreTasBetween(
    int lowerNbreTas,
    int upperNbreTas, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'nbreTas',
        lower: [lowerNbreTas],
        includeLower: includeLower,
        upper: [upperNbreTas],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension LigneQueryFilter on QueryBuilder<Ligne, Ligne, QFilterCondition> {
  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> libeleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'libele',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> libeleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'libele',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> libeleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'libele',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> libeleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'libele',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> libeleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'libele',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> libeleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'libele',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> libeleContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'libele',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> libeleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'libele',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> libeleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'libele',
        value: '',
      ));
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> libeleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'libele',
        value: '',
      ));
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> nbreTasEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nbreTas',
        value: value,
      ));
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> nbreTasGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nbreTas',
        value: value,
      ));
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> nbreTasLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nbreTas',
        value: value,
      ));
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> nbreTasBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nbreTas',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> poidsTotalEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'poidsTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> poidsTotalGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'poidsTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> poidsTotalLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'poidsTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> poidsTotalBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'poidsTotal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> tasLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tas',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> tasIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tas',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> tasIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tas',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> tasLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tas',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> tasLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tas',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> tasLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tas',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension LigneQueryObject on QueryBuilder<Ligne, Ligne, QFilterCondition> {
  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> tasElement(
      FilterQuery<Tas> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'tas');
    });
  }
}

extension LigneQueryLinks on QueryBuilder<Ligne, Ligne, QFilterCondition> {
  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> camions(
      FilterQuery<DechargerCours> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'camions');
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> camionsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'camions', length, true, length, true);
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> camionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'camions', 0, true, 0, true);
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> camionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'camions', 0, false, 999999, true);
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> camionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'camions', 0, true, length, include);
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> camionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'camions', length, include, 999999, true);
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> camionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'camions', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> agent(
      FilterQuery<Agent> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'agent');
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterFilterCondition> agentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'agent', 0, true, 0, true);
    });
  }
}

extension LigneQuerySortBy on QueryBuilder<Ligne, Ligne, QSortBy> {
  QueryBuilder<Ligne, Ligne, QAfterSortBy> sortByLibele() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libele', Sort.asc);
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterSortBy> sortByLibeleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libele', Sort.desc);
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterSortBy> sortByNbreTas() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nbreTas', Sort.asc);
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterSortBy> sortByNbreTasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nbreTas', Sort.desc);
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterSortBy> sortByPoidsTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsTotal', Sort.asc);
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterSortBy> sortByPoidsTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsTotal', Sort.desc);
    });
  }
}

extension LigneQuerySortThenBy on QueryBuilder<Ligne, Ligne, QSortThenBy> {
  QueryBuilder<Ligne, Ligne, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterSortBy> thenByLibele() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libele', Sort.asc);
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterSortBy> thenByLibeleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libele', Sort.desc);
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterSortBy> thenByNbreTas() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nbreTas', Sort.asc);
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterSortBy> thenByNbreTasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nbreTas', Sort.desc);
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterSortBy> thenByPoidsTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsTotal', Sort.asc);
    });
  }

  QueryBuilder<Ligne, Ligne, QAfterSortBy> thenByPoidsTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsTotal', Sort.desc);
    });
  }
}

extension LigneQueryWhereDistinct on QueryBuilder<Ligne, Ligne, QDistinct> {
  QueryBuilder<Ligne, Ligne, QDistinct> distinctByLibele(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libele', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Ligne, Ligne, QDistinct> distinctByNbreTas() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nbreTas');
    });
  }

  QueryBuilder<Ligne, Ligne, QDistinct> distinctByPoidsTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'poidsTotal');
    });
  }
}

extension LigneQueryProperty on QueryBuilder<Ligne, Ligne, QQueryProperty> {
  QueryBuilder<Ligne, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Ligne, String, QQueryOperations> libeleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libele');
    });
  }

  QueryBuilder<Ligne, int, QQueryOperations> nbreTasProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nbreTas');
    });
  }

  QueryBuilder<Ligne, double, QQueryOperations> poidsTotalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'poidsTotal');
    });
  }

  QueryBuilder<Ligne, List<Tas>, QQueryOperations> tasProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tas');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const TasSchema = Schema(
  name: r'Tas',
  id: -3089432045666156998,
  properties: {
    r'etat': PropertySchema(
      id: 0,
      name: r'etat',
      type: IsarType.long,
    ),
    r'id': PropertySchema(
      id: 1,
      name: r'id',
      type: IsarType.long,
    ),
    r'poids': PropertySchema(
      id: 2,
      name: r'poids',
      type: IsarType.double,
    )
  },
  estimateSize: _tasEstimateSize,
  serialize: _tasSerialize,
  deserialize: _tasDeserialize,
  deserializeProp: _tasDeserializeProp,
);

int _tasEstimateSize(
  Tas object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _tasSerialize(
  Tas object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.etat);
  writer.writeLong(offsets[1], object.id);
  writer.writeDouble(offsets[2], object.poids);
}

Tas _tasDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Tas(
    etat: reader.readLongOrNull(offsets[0]) ?? 0,
    id: reader.readLongOrNull(offsets[1]) ?? 0,
    poids: reader.readDoubleOrNull(offsets[2]) ?? 0.0,
  );
  return object;
}

P _tasDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 2:
      return (reader.readDoubleOrNull(offset) ?? 0.0) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension TasQueryFilter on QueryBuilder<Tas, Tas, QFilterCondition> {
  QueryBuilder<Tas, Tas, QAfterFilterCondition> etatEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'etat',
        value: value,
      ));
    });
  }

  QueryBuilder<Tas, Tas, QAfterFilterCondition> etatGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'etat',
        value: value,
      ));
    });
  }

  QueryBuilder<Tas, Tas, QAfterFilterCondition> etatLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'etat',
        value: value,
      ));
    });
  }

  QueryBuilder<Tas, Tas, QAfterFilterCondition> etatBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'etat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Tas, Tas, QAfterFilterCondition> idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Tas, Tas, QAfterFilterCondition> idGreaterThan(
    int value, {
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

  QueryBuilder<Tas, Tas, QAfterFilterCondition> idLessThan(
    int value, {
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

  QueryBuilder<Tas, Tas, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
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

  QueryBuilder<Tas, Tas, QAfterFilterCondition> poidsEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'poids',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Tas, Tas, QAfterFilterCondition> poidsGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'poids',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Tas, Tas, QAfterFilterCondition> poidsLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'poids',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Tas, Tas, QAfterFilterCondition> poidsBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'poids',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension TasQueryObject on QueryBuilder<Tas, Tas, QFilterCondition> {}
