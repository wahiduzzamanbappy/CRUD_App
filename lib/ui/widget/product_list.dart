import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../models/product.dart';
import '../screen/update_product_screen.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({super.key, required this.product});

  final Product product;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _priceTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();
  final TextEditingController _quantityTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();
  final TextEditingController _codeTEController = TextEditingController();

  bool _deleteProductInProgress = false;

  @override
  void initState() {
    super.initState();
    _nameTEController.text = widget.product.productName ?? '';
    _priceTEController.text = widget.product.unitPrice ?? '';
    _totalPriceTEController.text = widget.product.totalPrice ?? '';
    _quantityTEController.text = widget.product.quantity ?? '';
    _imageTEController.text = widget.product.image ?? '';
    _codeTEController.text = widget.product.productCode ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        widget.product.image ?? '',
        width: 40,
      ),
      title: Text(widget.product.productName ?? 'Unknown'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Product Code: ${widget.product.productCode ?? 'Unknown'}'),
          Text('Quantity: ${widget.product.quantity ?? 'Unknown'}'),
          Text('Price: ${widget.product.unitPrice ?? 'Unknown'}'),
          Text('Total Price: ${widget.product.totalPrice ?? 'Unknown'}'),
        ],
      ),
      trailing: Wrap(
        children: [
          IconButton(
              onPressed: () {
                _deleteProduct();
                setState(() {});
              },
              icon: const Icon(Icons.delete)),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                UpdateProductScreen.name,
                arguments: widget.product,
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProduct() async {
    _deleteProductInProgress = true;
    setState(() {});
    Uri uri = Uri.parse(
        'https://crud.teamrabbil.com/api/v1/DeleteProduct/${widget.product.id}');
    Response response = await get(uri);
    print(response.statusCode);
    print(response.body);
    _deleteProductInProgress = false;

    setState(() {});
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Delete Confirmed!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product Deleted failed! Try again.'),
        ),
      );
    }
  }
}
