// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAgentCollection on Isar {
  IsarCollection<Agent> get agents => this.collection();
}

const AgentSchema = CollectionSchema(
  name: r'Agent',
  id: 1260808932571846533,
  properties: {
    r'etatModification': PropertySchema(
      id: 0,
      name: r'etatModification',
      type: IsarType.bool,
    ),
    r'etatSynchronisation': PropertySchema(
      id: 1,
      name: r'etatSynchronisation',
      type: IsarType.bool,
    ),
    r'matricule': PropertySchema(
      id: 2,
      name: r'matricule',
      type: IsarType.string,
    ),
    r'password': PropertySchema(
      id: 3,
      name: r'password',
      type: IsarType.string,
    ),
    r'role': PropertySchema(
      id: 4,
      name: r'role',
      type: IsarType.string,
    )
  },
  estimateSize: _agentEstimateSize,
  serialize: _agentSerialize,
  deserialize: _agentDeserialize,
  deserializeProp: _agentDeserializeProp,
  idName: r'id',
  indexes: {
    r'matricule': IndexSchema(
      id: -2931968585082441240,
      name: r'matricule',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'matricule',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'password': IndexSchema(
      id: 3703496938144952218,
      name: r'password',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'password',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'role': IndexSchema(
      id: -7450883916179829259,
      name: r'role',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'role',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'etatSynchronisation': IndexSchema(
      id: -5526552659358308900,
      name: r'etatSynchronisation',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'etatSynchronisation',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'etatModification': IndexSchema(
      id: -980340134437142290,
      name: r'etatModification',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'etatModification',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _agentGetId,
  getLinks: _agentGetLinks,
  attach: _agentAttach,
  version: '3.1.0+1',
);

int _agentEstimateSize(
  Agent object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.matricule.length * 3;
  bytesCount += 3 + object.password.length * 3;
  bytesCount += 3 + object.role.length * 3;
  return bytesCount;
}

void _agentSerialize(
  Agent object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.etatModification);
  writer.writeBool(offsets[1], object.etatSynchronisation);
  writer.writeString(offsets[2], object.matricule);
  writer.writeString(offsets[3], object.password);
  writer.writeString(offsets[4], object.role);
}

Agent _agentDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Agent();
  object.etatModification = reader.readBool(offsets[0]);
  object.etatSynchronisation = reader.readBool(offsets[1]);
  object.id = id;
  object.matricule = reader.readString(offsets[2]);
  object.password = reader.readString(offsets[3]);
  object.role = reader.readString(offsets[4]);
  return object;
}

P _agentDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _agentGetId(Agent object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _agentGetLinks(Agent object) {
  return [];
}

void _agentAttach(IsarCollection<dynamic> col, Id id, Agent object) {
  object.id = id;
}

extension AgentQueryWhereSort on QueryBuilder<Agent, Agent, QWhere> {
  QueryBuilder<Agent, Agent, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Agent, Agent, QAfterWhere> anyEtatSynchronisation() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'etatSynchronisation'),
      );
    });
  }

  QueryBuilder<Agent, Agent, QAfterWhere> anyEtatModification() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'etatModification'),
      );
    });
  }
}

extension AgentQueryWhere on QueryBuilder<Agent, Agent, QWhereClause> {
  QueryBuilder<Agent, Agent, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Agent, Agent, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Agent, Agent, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Agent, Agent, QAfterWhereClause> idBetween(
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

  QueryBuilder<Agent, Agent, QAfterWhereClause> matriculeEqualTo(
      String matricule) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'matricule',
        value: [matricule],
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterWhereClause> matriculeNotEqualTo(
      String matricule) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'matricule',
              lower: [],
              upper: [matricule],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'matricule',
              lower: [matricule],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'matricule',
              lower: [matricule],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'matricule',
              lower: [],
              upper: [matricule],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Agent, Agent, QAfterWhereClause> passwordEqualTo(
      String password) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'password',
        value: [password],
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterWhereClause> passwordNotEqualTo(
      String password) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'password',
              lower: [],
              upper: [password],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'password',
              lower: [password],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'password',
              lower: [password],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'password',
              lower: [],
              upper: [password],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Agent, Agent, QAfterWhereClause> roleEqualTo(String role) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'role',
        value: [role],
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterWhereClause> roleNotEqualTo(String role) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'role',
              lower: [],
              upper: [role],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'role',
              lower: [role],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'role',
              lower: [role],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'role',
              lower: [],
              upper: [role],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Agent, Agent, QAfterWhereClause> etatSynchronisationEqualTo(
      bool etatSynchronisation) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'etatSynchronisation',
        value: [etatSynchronisation],
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterWhereClause> etatSynchronisationNotEqualTo(
      bool etatSynchronisation) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'etatSynchronisation',
              lower: [],
              upper: [etatSynchronisation],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'etatSynchronisation',
              lower: [etatSynchronisation],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'etatSynchronisation',
              lower: [etatSynchronisation],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'etatSynchronisation',
              lower: [],
              upper: [etatSynchronisation],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Agent, Agent, QAfterWhereClause> etatModificationEqualTo(
      bool etatModification) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'etatModification',
        value: [etatModification],
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterWhereClause> etatModificationNotEqualTo(
      bool etatModification) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'etatModification',
              lower: [],
              upper: [etatModification],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'etatModification',
              lower: [etatModification],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'etatModification',
              lower: [etatModification],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'etatModification',
              lower: [],
              upper: [etatModification],
              includeUpper: false,
            ));
      }
    });
  }
}

extension AgentQueryFilter on QueryBuilder<Agent, Agent, QFilterCondition> {
  QueryBuilder<Agent, Agent, QAfterFilterCondition> etatModificationEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'etatModification',
        value: value,
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterFilterCondition> etatSynchronisationEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'etatSynchronisation',
        value: value,
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Agent, Agent, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Agent, Agent, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Agent, Agent, QAfterFilterCondition> matriculeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'matricule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterFilterCondition> matriculeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'matricule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterFilterCondition> matriculeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'matricule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterFilterCondition> matriculeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'matricule',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterFilterCondition> matriculeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'matricule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterFilterCondition> matriculeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'matricule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterFilterCondition> matriculeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'matricule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterFilterCondition> matriculeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'matricule',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterFilterCondition> matriculeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'matricule',
        value: '',
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterFilterCondition> matriculeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'matricule',
        value: '',
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterFilterCondition> passwordEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'password',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterFilterCondition> passwordGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'password',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterFilterCondition> passwordLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'password',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterFilterCondition> passwordBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'password',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterFilterCondition> passwordStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'password',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterFilterCondition> passwordEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'password',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterFilterCondition> passwordContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'password',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterFilterCondition> passwordMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'password',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterFilterCondition> passwordIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'password',
        value: '',
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterFilterCondition> passwordIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'password',
        value: '',
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterFilterCondition> roleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'role',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterFilterCondition> roleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'role',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterFilterCondition> roleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'role',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterFilterCondition> roleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'role',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterFilterCondition> roleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'role',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterFilterCondition> roleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'role',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterFilterCondition> roleContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'role',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterFilterCondition> roleMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'role',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterFilterCondition> roleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'role',
        value: '',
      ));
    });
  }

  QueryBuilder<Agent, Agent, QAfterFilterCondition> roleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'role',
        value: '',
      ));
    });
  }
}

extension AgentQueryObject on QueryBuilder<Agent, Agent, QFilterCondition> {}

extension AgentQueryLinks on QueryBuilder<Agent, Agent, QFilterCondition> {}

extension AgentQuerySortBy on QueryBuilder<Agent, Agent, QSortBy> {
  QueryBuilder<Agent, Agent, QAfterSortBy> sortByEtatModification() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatModification', Sort.asc);
    });
  }

  QueryBuilder<Agent, Agent, QAfterSortBy> sortByEtatModificationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatModification', Sort.desc);
    });
  }

  QueryBuilder<Agent, Agent, QAfterSortBy> sortByEtatSynchronisation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatSynchronisation', Sort.asc);
    });
  }

  QueryBuilder<Agent, Agent, QAfterSortBy> sortByEtatSynchronisationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatSynchronisation', Sort.desc);
    });
  }

  QueryBuilder<Agent, Agent, QAfterSortBy> sortByMatricule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matricule', Sort.asc);
    });
  }

  QueryBuilder<Agent, Agent, QAfterSortBy> sortByMatriculeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matricule', Sort.desc);
    });
  }

  QueryBuilder<Agent, Agent, QAfterSortBy> sortByPassword() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'password', Sort.asc);
    });
  }

  QueryBuilder<Agent, Agent, QAfterSortBy> sortByPasswordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'password', Sort.desc);
    });
  }

  QueryBuilder<Agent, Agent, QAfterSortBy> sortByRole() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'role', Sort.asc);
    });
  }

  QueryBuilder<Agent, Agent, QAfterSortBy> sortByRoleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'role', Sort.desc);
    });
  }
}

extension AgentQuerySortThenBy on QueryBuilder<Agent, Agent, QSortThenBy> {
  QueryBuilder<Agent, Agent, QAfterSortBy> thenByEtatModification() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatModification', Sort.asc);
    });
  }

  QueryBuilder<Agent, Agent, QAfterSortBy> thenByEtatModificationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatModification', Sort.desc);
    });
  }

  QueryBuilder<Agent, Agent, QAfterSortBy> thenByEtatSynchronisation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatSynchronisation', Sort.asc);
    });
  }

  QueryBuilder<Agent, Agent, QAfterSortBy> thenByEtatSynchronisationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatSynchronisation', Sort.desc);
    });
  }

  QueryBuilder<Agent, Agent, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Agent, Agent, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Agent, Agent, QAfterSortBy> thenByMatricule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matricule', Sort.asc);
    });
  }

  QueryBuilder<Agent, Agent, QAfterSortBy> thenByMatriculeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matricule', Sort.desc);
    });
  }

  QueryBuilder<Agent, Agent, QAfterSortBy> thenByPassword() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'password', Sort.asc);
    });
  }

  QueryBuilder<Agent, Agent, QAfterSortBy> thenByPasswordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'password', Sort.desc);
    });
  }

  QueryBuilder<Agent, Agent, QAfterSortBy> thenByRole() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'role', Sort.asc);
    });
  }

  QueryBuilder<Agent, Agent, QAfterSortBy> thenByRoleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'role', Sort.desc);
    });
  }
}

extension AgentQueryWhereDistinct on QueryBuilder<Agent, Agent, QDistinct> {
  QueryBuilder<Agent, Agent, QDistinct> distinctByEtatModification() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'etatModification');
    });
  }

  QueryBuilder<Agent, Agent, QDistinct> distinctByEtatSynchronisation() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'etatSynchronisation');
    });
  }

  QueryBuilder<Agent, Agent, QDistinct> distinctByMatricule(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'matricule', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Agent, Agent, QDistinct> distinctByPassword(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'password', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Agent, Agent, QDistinct> distinctByRole(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'role', caseSensitive: caseSensitive);
    });
  }
}

extension AgentQueryProperty on QueryBuilder<Agent, Agent, QQueryProperty> {
  QueryBuilder<Agent, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Agent, bool, QQueryOperations> etatModificationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'etatModification');
    });
  }

  QueryBuilder<Agent, bool, QQueryOperations> etatSynchronisationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'etatSynchronisation');
    });
  }

  QueryBuilder<Agent, String, QQueryOperations> matriculeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'matricule');
    });
  }

  QueryBuilder<Agent, String, QQueryOperations> passwordProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'password');
    });
  }

  QueryBuilder<Agent, String, QQueryOperations> roleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'role');
    });
  }
}
