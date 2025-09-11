String titleForCategory(String category) {
  switch (category) {
    case 'daily':
    case 'Daily Communication':
      return 'Daily Communication';
    case 'family':
    case 'Family, Relationships, and Social Life':
      return 'Family, Relationships, and Social Life';
    case 'education':
    case 'Learning, Work, and Technology':
      return 'Learning, Work, and Technology';
    case 'travel':
    case 'Travel, Food, and Environment':
      return 'Travel, Food, and Environment';
    case 'emergency':
    case 'Interactive Learning and Emergency':
      return 'Interactive Learning and Emergency';
    default:
      return category;
  }
}
