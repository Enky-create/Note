class CloudStorageException implements Exception {
  const CloudStorageException();
}

// C in CRUD
class CouldNotCreateNoteException implements CloudStorageException {}

//R in CRUD
class CouldNotGetAllNoteException implements CloudStorageException {}

//U in Crud
class CouldNotUpdateNoteException implements CloudStorageException {}

//D in CRUD
class CouldNotDeleteNoteException implements CloudStorageException {}
