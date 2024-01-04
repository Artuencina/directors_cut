// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ProjectDao? _projectDaoInstance;

  SceneDao? _sceneDaoInstance;

  AnnotationDao? _annotationDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 3,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `projects` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `scenes` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `projectId` INTEGER, `name` TEXT NOT NULL, `orderId` INTEGER NOT NULL, FOREIGN KEY (`projectId`) REFERENCES `projects` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `annotations` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `sceneId` INTEGER, `title` TEXT NOT NULL, `description` TEXT NOT NULL, `type` TEXT NOT NULL, `orderId` INTEGER, `color` TEXT, `url` TEXT, `songStart` INTEGER, `songEnd` INTEGER, `playType` TEXT, `soundType` TEXT, `volume` INTEGER, FOREIGN KEY (`sceneId`) REFERENCES `scenes` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ProjectDao get projectDao {
    return _projectDaoInstance ??= _$ProjectDao(database, changeListener);
  }

  @override
  SceneDao get sceneDao {
    return _sceneDaoInstance ??= _$SceneDao(database, changeListener);
  }

  @override
  AnnotationDao get annotationDao {
    return _annotationDaoInstance ??= _$AnnotationDao(database, changeListener);
  }
}

class _$ProjectDao extends ProjectDao {
  _$ProjectDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _projectEntityInsertionAdapter = InsertionAdapter(
            database,
            'projects',
            (ProjectEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description
                }),
        _projectEntityUpdateAdapter = UpdateAdapter(
            database,
            'projects',
            ['id'],
            (ProjectEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description
                }),
        _projectEntityDeletionAdapter = DeletionAdapter(
            database,
            'projects',
            ['id'],
            (ProjectEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ProjectEntity> _projectEntityInsertionAdapter;

  final UpdateAdapter<ProjectEntity> _projectEntityUpdateAdapter;

  final DeletionAdapter<ProjectEntity> _projectEntityDeletionAdapter;

  @override
  Future<List<ProjectEntity>> getProjects() async {
    return _queryAdapter.queryList('SELECT * FROM projects',
        mapper: (Map<String, Object?> row) => ProjectEntity(
            name: row['name'] as String,
            id: row['id'] as int?,
            description: row['description'] as String));
  }

  @override
  Future<ProjectEntity?> getProject(String id) async {
    return _queryAdapter.query('SELECT * FROM projects WHERE id = ?1',
        mapper: (Map<String, Object?> row) => ProjectEntity(
            name: row['name'] as String,
            id: row['id'] as int?,
            description: row['description'] as String),
        arguments: [id]);
  }

  @override
  Future<void> createProject(ProjectEntity project) async {
    await _projectEntityInsertionAdapter.insert(
        project, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateProject(ProjectEntity project) async {
    await _projectEntityUpdateAdapter.update(project, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteProject(ProjectEntity project) async {
    await _projectEntityDeletionAdapter.delete(project);
  }
}

class _$SceneDao extends SceneDao {
  _$SceneDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _sceneEntityInsertionAdapter = InsertionAdapter(
            database,
            'scenes',
            (SceneEntity item) => <String, Object?>{
                  'id': item.id,
                  'projectId': item.projectId,
                  'name': item.name,
                  'orderId': item.orderId
                }),
        _sceneEntityUpdateAdapter = UpdateAdapter(
            database,
            'scenes',
            ['id'],
            (SceneEntity item) => <String, Object?>{
                  'id': item.id,
                  'projectId': item.projectId,
                  'name': item.name,
                  'orderId': item.orderId
                }),
        _sceneEntityDeletionAdapter = DeletionAdapter(
            database,
            'scenes',
            ['id'],
            (SceneEntity item) => <String, Object?>{
                  'id': item.id,
                  'projectId': item.projectId,
                  'name': item.name,
                  'orderId': item.orderId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SceneEntity> _sceneEntityInsertionAdapter;

  final UpdateAdapter<SceneEntity> _sceneEntityUpdateAdapter;

  final DeletionAdapter<SceneEntity> _sceneEntityDeletionAdapter;

  @override
  Future<List<SceneEntity>> getScenes(String projectId) async {
    return _queryAdapter.queryList('SELECT * FROM scenes WHERE projectId = ?1',
        mapper: (Map<String, Object?> row) => SceneEntity(
            id: row['id'] as int?,
            projectId: row['projectId'] as int?,
            name: row['name'] as String,
            orderId: row['orderId'] as int),
        arguments: [projectId]);
  }

  @override
  Future<SceneEntity?> getScene(String id) async {
    return _queryAdapter.query('SELECT * FROM scenes WHERE id = ?1',
        mapper: (Map<String, Object?> row) => SceneEntity(
            id: row['id'] as int?,
            projectId: row['projectId'] as int?,
            name: row['name'] as String,
            orderId: row['orderId'] as int),
        arguments: [id]);
  }

  @override
  Future<void> createScene(SceneEntity scene) async {
    await _sceneEntityInsertionAdapter.insert(scene, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateScene(SceneEntity scene) async {
    await _sceneEntityUpdateAdapter.update(scene, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateScenes(List<SceneEntity> scenes) async {
    await _sceneEntityUpdateAdapter.updateList(
        scenes, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteScene(SceneEntity scene) async {
    await _sceneEntityDeletionAdapter.delete(scene);
  }
}

class _$AnnotationDao extends AnnotationDao {
  _$AnnotationDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _annotationEntityInsertionAdapter = InsertionAdapter(
            database,
            'annotations',
            (AnnotationEntity item) => <String, Object?>{
                  'id': item.id,
                  'sceneId': item.sceneId,
                  'title': item.title,
                  'description': item.description,
                  'type': item.type,
                  'orderId': item.orderId,
                  'color': item.color,
                  'url': item.url,
                  'songStart': item.songStart,
                  'songEnd': item.songEnd,
                  'playType': item.playType,
                  'soundType': item.soundType,
                  'volume': item.volume
                }),
        _annotationEntityUpdateAdapter = UpdateAdapter(
            database,
            'annotations',
            ['id'],
            (AnnotationEntity item) => <String, Object?>{
                  'id': item.id,
                  'sceneId': item.sceneId,
                  'title': item.title,
                  'description': item.description,
                  'type': item.type,
                  'orderId': item.orderId,
                  'color': item.color,
                  'url': item.url,
                  'songStart': item.songStart,
                  'songEnd': item.songEnd,
                  'playType': item.playType,
                  'soundType': item.soundType,
                  'volume': item.volume
                }),
        _annotationEntityDeletionAdapter = DeletionAdapter(
            database,
            'annotations',
            ['id'],
            (AnnotationEntity item) => <String, Object?>{
                  'id': item.id,
                  'sceneId': item.sceneId,
                  'title': item.title,
                  'description': item.description,
                  'type': item.type,
                  'orderId': item.orderId,
                  'color': item.color,
                  'url': item.url,
                  'songStart': item.songStart,
                  'songEnd': item.songEnd,
                  'playType': item.playType,
                  'soundType': item.soundType,
                  'volume': item.volume
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AnnotationEntity> _annotationEntityInsertionAdapter;

  final UpdateAdapter<AnnotationEntity> _annotationEntityUpdateAdapter;

  final DeletionAdapter<AnnotationEntity> _annotationEntityDeletionAdapter;

  @override
  Future<List<AnnotationEntity>> getAnnotations(int sceneId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM annotations where sceneId = ?1',
        mapper: (Map<String, Object?> row) => AnnotationEntity(
            id: row['id'] as int?,
            sceneId: row['sceneId'] as int?,
            title: row['title'] as String,
            description: row['description'] as String,
            orderId: row['orderId'] as int?,
            color: row['color'] as String?,
            url: row['url'] as String?,
            songStart: row['songStart'] as int?,
            songEnd: row['songEnd'] as int?,
            type: row['type'] as String,
            playType: row['playType'] as String?,
            soundType: row['soundType'] as String?,
            volume: row['volume'] as int?),
        arguments: [sceneId]);
  }

  @override
  Future<AnnotationEntity?> getAnnotation(int id) async {
    return _queryAdapter.query('SELECT * FROM annotations WHERE id = ?1',
        mapper: (Map<String, Object?> row) => AnnotationEntity(
            id: row['id'] as int?,
            sceneId: row['sceneId'] as int?,
            title: row['title'] as String,
            description: row['description'] as String,
            orderId: row['orderId'] as int?,
            color: row['color'] as String?,
            url: row['url'] as String?,
            songStart: row['songStart'] as int?,
            songEnd: row['songEnd'] as int?,
            type: row['type'] as String,
            playType: row['playType'] as String?,
            soundType: row['soundType'] as String?,
            volume: row['volume'] as int?),
        arguments: [id]);
  }

  @override
  Future<void> deleteAllAnnotations(int sceneId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM annotations WHERE sceneId = ?1',
        arguments: [sceneId]);
  }

  @override
  Future<void> createAnnotation(AnnotationEntity annotation) async {
    await _annotationEntityInsertionAdapter.insert(
        annotation, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateAnnotation(AnnotationEntity annotation) async {
    await _annotationEntityUpdateAdapter.update(
        annotation, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateAnnotations(List<AnnotationEntity> annotations) async {
    await _annotationEntityUpdateAdapter.updateList(
        annotations, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteAnnotation(AnnotationEntity annotation) async {
    await _annotationEntityDeletionAdapter.delete(annotation);
  }
}
