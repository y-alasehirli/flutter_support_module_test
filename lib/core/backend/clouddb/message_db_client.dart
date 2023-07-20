abstract class MessageDBClient<T, O> {
  Future<bool> saveMessage(T item, bool isAdmin);
  Future<void> deleteMessage(T item, bool isAdmin);
  Stream<List<T>?> getMessages(O custo, O admin);
}
