import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importe o pacote intl para formatar a data
import 'package:project_crud/models/doing.dart';
import 'package:project_crud/provider/users.dart';
import 'package:provider/provider.dart';

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _form = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  DateTime? _selectedDate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Doing? doing = ModalRoute.of(context)?.settings.arguments as Doing?;
    if (doing != null) {
      _formData['id'] = doing.id;
      _formData['name'] = doing.name;
      _selectedDate = doing.dueDate; // Atribui diretamente o DateTime
    }
  }

  void _saveForm() {
    _form.currentState?.save();

    String id = _formData['id'] ?? '';
    String name = _formData['name'] ?? '';
    DateTime dueDate = _selectedDate ?? DateTime.now();

    Provider.of<UsersProvider>(context, listen: false).put(
      Doing(id: id, name: name, dueDate: dueDate),
    );
    Navigator.of(context).pop();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate ?? DateTime.now()),
      );
      if (time != null) {
        setState(() {
          _selectedDate =
              DateTime(date.year, date.month, date.day, time.hour, time.minute);
          // Atualizar também o _formData['dueDate'] com a nova data e hora selecionadas
          _formData['dueDate'] = _selectedDate;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Doing? doing = ModalRoute.of(context)?.settings.arguments as Doing?;
    final isEditing = doing != null; // Checa se está editando

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Tarefa' : 'Adicionar Tarefa'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                initialValue: _formData['name'],
                decoration: InputDecoration(labelText: 'Nome da Tarefa'),
                onSaved: (newValue) => _formData['name'] = newValue!,
              ),
              SizedBox(height: 20), // Adiciona espaço vertical
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'Nenhuma data selecionada!'
                          : DateFormat('dd/MM/yyyy HH:mm')
                              .format(_selectedDate!),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDateTime,
                    child: Text('Selecionar Data e Hora'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
