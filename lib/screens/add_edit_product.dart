import 'dart:io';

import 'package:arkroot_shop/models/product.dart';
import 'package:arkroot_shop/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/EditProductScreen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  File? _image;
  final picker = ImagePicker();

  Product _editingProduct = Product(
    id: '',
    title: '',
    description: '',
    image: '',
    price: 0,
    variants: [],
  );

  bool _isInit = true;

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState?.validate();
    if (isValid == false) {
      return;
    }
    _formKey.currentState?.save();

    final productData = Provider.of<Products>(context, listen: false);

    if (_editingProduct.id != '') {
      productData.updateProduct(_editingProduct.id, _editingProduct);
    } else {
      await productData.addProduct(_editingProduct);
    }

    Navigator.of(context).pop();
  }

  Future _updateImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _editingProduct = Product(
          id: _editingProduct.id,
          title: _editingProduct.title,
          price: _editingProduct.price,
          description: _editingProduct.description,
          image: _image?.path ?? '',
          variants: _editingProduct.variants,
        );
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final String productId =
          ModalRoute.of(context)?.settings.arguments as String;

      Product? product = Provider.of<Products>(context, listen: false)
          .getProductById(productId);
      if (product != null) {
        _editingProduct = product;
        //_imageURLController.text = _editingProduct.image;
      }
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  shadowColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 4,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Title',
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          initialValue: _editingProduct.title,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
                          },
                          validator: (value) {
                            if (value == null) {
                              return "Title can't be empty.";
                            }
                            if (value.length < 5) {
                              return 'Title should be at least 5 characters long.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editingProduct = Product(
                              id: _editingProduct.id,
                              title: value ?? '',
                              price: _editingProduct.price,
                              description: _editingProduct.description,
                              image: _editingProduct.image,
                              variants: _editingProduct.variants,
                            );
                          },
                        ),
                      ),
                      Divider(color: Theme.of(context).primaryColor),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Description',
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          initialValue: _editingProduct.description,
                          maxLines: 2,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionFocusNode,
                          validator: (value) {
                            if (value == null) {
                              return 'Please enter a description';
                            }
                            if (value.length < 10) {
                              return 'Description should be at least 10 characters';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editingProduct = Product(
                              id: _editingProduct.id,
                              title: _editingProduct.title,
                              price: _editingProduct.price,
                              description: value ?? '',
                              image: _editingProduct.image,
                              variants: _editingProduct.variants,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  shadowColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 4,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Price',
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          initialValue:
                              _editingProduct.price.toStringAsFixed(2),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: _priceFocusNode,
                          validator: (value) {
                            if (value == null) {
                              return 'Please enter price';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            if (double.parse(value) <= 0) {
                              return 'Please enter a number greater than zero';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_descriptionFocusNode);
                          },
                          onSaved: (value) {
                            _editingProduct = Product(
                              id: _editingProduct.id,
                              title: _editingProduct.title,
                              price: double.parse(value ??
                                  ''), //IF value is null this case will be catched by validator before reaching this.
                              description: _editingProduct.description,
                              image: _editingProduct.image,
                              variants: _editingProduct.variants,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      shadowColor: Theme.of(context).primaryColor,
                      elevation: 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: _editingProduct.image == ''
                            ? Container(
                                width: 100,
                                height: 100,
                                child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text('Image not selected')),
                              )
                            : FittedBox(
                                child: Image.file(
                                  File(_editingProduct.image),
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(width: 32),
                    Card(
                      shadowColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 4,
                      child: InkWell(
                        onTap: _updateImage,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Icon(Icons.add_a_photo,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Variants',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                for (int i = 0; i < _editingProduct.variants.length; i++)
                  Card(
                    shadowColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 4,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Variant Category',
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            initialValue:
                                _editingProduct.variants[i].variantCategory,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null) {
                                return "Variant category can't be empty. Ex Color, RAM etc.";
                              }

                              return null;
                            },
                            onSaved: (value) {
                              Variants variant = _editingProduct.variants[i];
                              variant.variantCategory = value;
                              _editingProduct.variants[i] = variant;

                              _editingProduct = Product(
                                id: _editingProduct.id,
                                title: _editingProduct.title,
                                price: _editingProduct.price,
                                description: _editingProduct.description,
                                image: _editingProduct.image,
                                variants: _editingProduct.variants,
                              );
                            },
                          ),
                        ),
                        Divider(color: Theme.of(context).primaryColor),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Variant Title',
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            initialValue:
                                _editingProduct.variants[i].variantTitle,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null) {
                                return "Variant title can't be empty. Ex 64 GB memory, 128 GB memory etc.";
                              }

                              return null;
                            },
                            onSaved: (value) {
                              Variants variant = _editingProduct.variants[i];
                              variant.variantTitle = value;
                              _editingProduct.variants[i] = variant;

                              _editingProduct = Product(
                                id: _editingProduct.id,
                                title: _editingProduct.title,
                                price: _editingProduct.price,
                                description: _editingProduct.description,
                                image: _editingProduct.image,
                                variants: _editingProduct.variants,
                              );
                            },
                          ),
                        ),
                        Divider(color: Theme.of(context).primaryColor),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Additional price',
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            initialValue: (_editingProduct
                                        .variants[i].variantAdditionalPrice ??
                                    '')
                                .toString(),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter price';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              if (double.parse(value) < 0) {
                                return 'Please enter a non negative number';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              Variants variant = _editingProduct.variants[i];
                              variant.variantAdditionalPrice =
                                  double.parse(value ?? '');
                              _editingProduct.variants[i] = variant;

                              _editingProduct = Product(
                                id: _editingProduct.id,
                                title: _editingProduct.title,
                                price: _editingProduct.price,
                                description: _editingProduct.description,
                                image: _editingProduct.image,
                                variants: _editingProduct.variants,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _editingProduct.variants.add(Variants());
                        });
                      },
                      icon: Icon(Icons.add),
                      label: Text('Variant Details'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
