class GroupArgs {
  final int id;
  final String groupName;
  final String title;
  final Map<String, Object> tasks;
  final List<String> members;

  GroupArgs(this.id, this.groupName, this.title, this.tasks, this.members);
}