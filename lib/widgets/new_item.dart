import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  final _formkey = GlobalKey<FormState>();
  var _enteredTitle = '';
  var _enteredAmount = 1;
  var _enteredCategory = categories[Categories.dairy]!;

  void _saveItem() {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      Navigator.of(context).pop(GroceryItem(
          id: DateTime.now().toString(),
          name: _enteredTitle,
          quantity: _enteredAmount,
          category: _enteredCategory));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new Item"),
      ),
      body: Form(
        key: _formkey,
        child: Column(
          children: [
            TextFormField(
              maxLength: 50,
              onSaved: (value) {
                _enteredTitle = value!;
              },
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value.trim().length <= 1 ||
                    value.trim().length > 50) {
                  return "Enter title with length between 2 to 50";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFormField(
                    maxLength: 50,
                    initialValue: '1',
                    decoration: const InputDecoration(label: Text("Quantity")),
                    onSaved: (value) {
                      _enteredAmount = int.parse(value!);
                    },
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          int.tryParse(value) == null ||
                          int.tryParse(value)! <= 0) {
                        return "Enter positive quantity number";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: DropdownButtonFormField(
                      value: _enteredCategory,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  color: category.value.color,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(category.value.title)
                              ],
                            ),
                          )
                      ],
                      onChanged: (value) {
                        setState(() {
                          _enteredCategory = value!;
                        });
                      }),
                )
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      _formkey.currentState!.reset();
                    },
                    child: const Text("Reset")),
                TextButton(onPressed: _saveItem, child: const Text("Add Item"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
