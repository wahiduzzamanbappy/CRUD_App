
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AddNewProductScreen extends StatefulWidget {
  const AddNewProductScreen({super.key});

  static const String name = '/add-new-product';

  @override
  State<AddNewProductScreen> createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _priceTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();
  final TextEditingController _quantityTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();
  final TextEditingController _codeTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _addNewProductInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 73, 115, 121),
        title: const Text('Add new Product',
            style: TextStyle(
              color: Colors.white,
            )),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _buildProductForm(),
        ),
      ),
    );
  }

  Widget _buildProductForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _nameTEController,
              decoration: const InputDecoration(
                hintText: 'Name',
                labelText: 'Product Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
              ),
              validator: (String? value) {
                if (value?.trim().isEmpty ?? true) {
                  return 'Enter product Name';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _codeTEController,
              decoration: const InputDecoration(
                hintText: 'Code',
                labelText: 'Product Code',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
              ),
              validator: (String? value) {
                if (value?.trim().isEmpty ?? true) {
                  return 'Enter product code';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _imageTEController,
              decoration: const InputDecoration(
                hintText: 'Image',
                labelText: 'Image url',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
              ),
              validator: (String? value) {
                if (value?.trim().isEmpty ?? true) {
                  return 'Enter Image url';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _priceTEController,
              decoration: const InputDecoration(
                hintText: 'Price',
                labelText: 'Unit Price',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
              ),
              validator: (String? value) {
                if (value?.trim().isEmpty ?? true) {
                  return 'Enter product price';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _quantityTEController,
              decoration: const InputDecoration(
                hintText: 'Quantity',
                labelText: 'Product Quantity',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
              ),
              validator: (String? value) {
                if (value?.trim().isEmpty ?? true) {
                  return 'Enter product Quantity';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _totalPriceTEController,
              decoration: const InputDecoration(
                hintText: 'Total Price',
                labelText: 'Product Total Price',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
              ),
              validator: (String? value) {
                if (value?.trim().isEmpty ?? true) {
                  return 'Enter product total price';
                }
                return null;
              },
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Visibility(
            visible: _addNewProductInProgress == false,
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 73, 115, 121),
                elevation: 5,
                minimumSize: const Size(300, 50),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _addNewProduct();
                }
              },
              child: const Text(
                'Add Product',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _addNewProduct() async {
    _addNewProductInProgress = true;
    setState(() {});
    Uri uri = Uri.parse('https://crud.teamrabbil.com/api/v1/CreateProduct');

    Map<String, dynamic> requestBody = {
      "Img": _imageTEController.text.trim(),
      "ProductCode": _codeTEController.text.trim(),
      "ProductName": _nameTEController.text.trim(),
      "Qty": _quantityTEController.text.trim(),
      "TotalPrice": _totalPriceTEController.text.trim(),
      "UnitPrice": _priceTEController.text.trim()
    };

    Response response = await post(
      uri,
      headers: {'Content-type': 'application/json'},
      body: jsonEncode(requestBody),
    );
    print(response.statusCode);
    print(response.body);
    _addNewProductInProgress = false;
    setState(() {});
    if (response.statusCode == 200) {
      _clearTextFields();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New product added!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New product add failed! Try again.'),
        ),
      );
    }
  }

  void _clearTextFields() {
    _nameTEController.clear();
    _codeTEController.clear();
    _priceTEController.clear();
    _totalPriceTEController.clear();
    _imageTEController.clear();
    _quantityTEController.clear();
  }

  @override
  void dispose() {
    _nameTEController.dispose();
    _codeTEController.dispose();
    _priceTEController.dispose();
    _totalPriceTEController.dispose();
    _imageTEController.dispose();
    _quantityTEController.dispose();
    super.dispose();
  }
}




