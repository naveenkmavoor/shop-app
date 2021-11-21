import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/providers.dart';

class ProductEdit extends StatefulWidget {
  static const routeName = '/productedit';

  const ProductEdit({Key? key}) : super(key: key);

  @override
  State<ProductEdit> createState() => _ProductEditState();
}

class _ProductEditState extends State<ProductEdit> {
  final _descriptionfocusnode = FocusNode();
  final _pricefocusnode = FocusNode();
  var _imageUrlcontroller = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  Product _product =
      Product(id: '', title: '', description: '', price: 0, imageUrl: '');
  bool _isInit = true;
  bool _isLoading = false;
  bool _isAdded = true;
  var initValue = {'title': '', 'description': '', 'price': ''};
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments;

      if (productId != null) {
        _product = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId.toString());
        print(_product.isFavorite);
        initValue = {
          'title': _product.title,
          'description': _product.description,
          'price': _product.price.toString(),
        };
        _imageUrlcontroller.text = _product.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
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

  void _saveValue() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_product.id.isNotEmpty) {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(_product);
      } catch (err) {
        showAlert(context);
      }
    } else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_product);

        print('Hello');
      } catch (err) {
        showAlert(context);
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context, _isAdded);
      }
    }
  }

  void showAlert(BuildContext context) async {
    _isAdded = await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Oops!'),
            content: Text('Somthing went wrong'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('OK'))
            ],
          );
        });
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(13.0),
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: initValue['title'],
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionfocusnode);
                      },
                      textInputAction: TextInputAction.next,
                      onSaved: (val) {
                        _product = Product(
                            id: _product.id,
                            isFavorite: _product.isFavorite,
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
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          prefixIcon: Icon(Icons.shopping_bag_rounded)),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    TextFormField(
                      initialValue: initValue['description'],
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_pricefocusnode);
                      },
                      focusNode: _descriptionfocusnode,
                      maxLines: 3,
                      maxLength: 50,
                      onSaved: (val) {
                        _product = Product(
                            id: _product.id,
                            isFavorite: _product.isFavorite,
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
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          label: Text('Add a Description'),
                          prefixIcon: Icon(Icons.shop_two_rounded)),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    TextFormField(
                      initialValue: initValue['price'],
                      focusNode: _pricefocusnode,
                      keyboardType: TextInputType.number,
                      onSaved: (val) {
                        _product = Product(
                            id: _product.id,
                            isFavorite: _product.isFavorite,
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
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          prefixIcon: Icon(Icons.attach_money_outlined)),
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
                                  isFavorite: _product.isFavorite,
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
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              prefixIcon: Icon(Icons.link),
                              label: Text('Enter image url'),
                            ),
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveValue();
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 30.0, left: 10.0),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: Colors.grey,
                              )),
                          child: _imageUrlcontroller.text.isEmpty
                              ? Icon(
                                  Icons.image,
                                  color: Colors.grey,
                                )
                              : FittedBox(
                                  fit: BoxFit.fill,
                                  child:
                                      Image.network(_imageUrlcontroller.text),
                                ),
                        ),
                      ],
                    ),
                  ],
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
