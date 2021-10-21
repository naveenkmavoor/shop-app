import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/models/products_provider.dart';

class ProductEdit extends StatefulWidget {
  static const routeName = '/productedit';

  const ProductEdit({Key? key}) : super(key: key);

  @override
  State<ProductEdit> createState() => _ProductEditState();
}

class _ProductEditState extends State<ProductEdit> {
  final _descriptionfocusnode = FocusNode();
  final _pricefocusnode = FocusNode();
  final _imageUrlcontroller = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  Product _product =
      Product(id: '', title: '', description: '', price: 0, imageUrl: '');
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlcontroller.text.isEmpty) {
        return;
      } else if (!_imageUrlcontroller.text.startsWith('http') &&
          !_imageUrlcontroller.text.startsWith('https')) {
        return;
      } else if (!_imageUrlcontroller.text.endsWith('.png') &&
          !_imageUrlcontroller.text.endsWith('.jpg') &&
          !_imageUrlcontroller.text.endsWith('.jpeg')) {
        return;
      }
      setState(() {});
    }
  }

  void _saveValue() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    _product = Product(
        id: DateTime.now().toString(),
        title: _product.title,
        description: _product.description,
        price: _product.price,
        imageUrl: _product.imageUrl);
    Provider.of<ProductsProvider>(context, listen: false).addProduct(_product);
    Navigator.pop(context, true);
    print(_product.title);
    print(_product.description);
    print(_product.price);
    print(_product.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new product'),
        actions: [
          TextButton(
            onPressed: _saveValue,
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionfocusnode);
                  },
                  textInputAction: TextInputAction.next,
                  onSaved: (val) {
                    _product = Product(
                        id: _product.id,
                        title: val!,
                        description: _product.description,
                        price: _product.price,
                        imageUrl: _product.imageUrl);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Product name is required.';
                    }
                    if (value.length > 40) {
                      return 'Too lengthy. Try to shorten the title.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      label: Text('Product Name'),
                      icon: Icon(Icons.shopping_bag_rounded)),
                ),
                TextFormField(
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_pricefocusnode);
                  },
                  focusNode: _descriptionfocusnode,
                  maxLines: 3,
                  maxLength: 50,
                  onSaved: (val) {
                    _product = Product(
                        id: _product.id,
                        title: _product.title,
                        description: val!,
                        price: _product.price,
                        imageUrl: _product.imageUrl);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Product description is required.';
                    } else if (value.length < 10) {
                      return 'Should be lengthy enough.';
                    } else if (value.length > 200) {
                      return 'Can\'t be too lengthy.';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      label: Text('Add a Description'),
                      icon: Icon(Icons.shop_two_rounded)),
                ),
                TextFormField(
                  focusNode: _pricefocusnode,
                  keyboardType: TextInputType.number,
                  onSaved: (val) {
                    _product = Product(
                        id: _product.id,
                        title: _product.title,
                        description: _product.description,
                        price: double.parse(val!),
                        imageUrl: _product.imageUrl);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Price is required';
                    } else if (double.tryParse(value) == null) {
                      return 'Enter a valid Price.';
                    } else if (double.parse(value) == 0) {
                      return 'Set a minimum price.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      label: Text('Price'),
                      icon: Icon(Icons.attach_money_outlined)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _imageUrlcontroller,
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        onSaved: (val) {
                          _product = Product(
                              id: _product.id,
                              title: _product.title,
                              description: _product.description,
                              price: _product.price,
                              imageUrl: val!);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'URL for image is required.';
                          } else if (!value.startsWith('http') &&
                              !value.startsWith('https')) {
                            return 'Invalid url';
                          } else if (!value.endsWith('.png') &&
                              !value.endsWith('.jpg') &&
                              !value.endsWith('.jpeg')) {
                            return 'Enter a valid url.';
                          }
                        },
                        decoration: InputDecoration(
                          icon: Icon(Icons.link),
                          label: Text('Enter image url'),
                        ),
                        focusNode: _imageUrlFocusNode,
                        onFieldSubmitted: (_) {
                          _saveValue();
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20.0, left: 10.0),
                      width: 100,
                      height: 100,
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.grey)),
                      child: _imageUrlcontroller.text.isEmpty
                          ? Text('Enter a URL')
                          : FittedBox(
                              fit: BoxFit.fill,
                              child: Image.network(_imageUrlcontroller.text),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _descriptionfocusnode.dispose();
    _pricefocusnode.dispose();
    _imageUrlcontroller.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }
}
