import 'package:project_crud/models/doing.dart';

final Map<String, Doing> TO_DO ={
  '1': Doing(
    id: '1',
    name: 'Almoço',
    dueDate: DateTime(2023, 4, 10, 12, 30), // Exemplo: 10 de Abril de 2023, 12:30
  ),
  '2': Doing(
    id: '2',
    name: 'Limpar Janela',
    dueDate: DateTime(2023, 4, 11, 10, 0), // Exemplo: 11 de Abril de 2023, 10:00
  ),
  '3': Doing(
    id: '3',
    name: 'Lavar Louça',
    dueDate: DateTime(2023, 4, 12, 15, 45), // Exemplo: 12 de Abril de 2023, 15:45
  ),
};
