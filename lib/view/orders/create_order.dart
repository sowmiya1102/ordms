import 'package:flutter/material.dart';
import 'package:ordms/viewmodels/order_view_model.dart';
import 'package:provider/provider.dart';

class CreateOrder extends StatefulWidget {
  const CreateOrder({super.key});

  @override
  State<CreateOrder> createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrder> {
  String? selectedItem;
  var orderItems = [
      'Lights',
      'Tents',
      'Chairs',
  ];
  final TextEditingController orderItemController = TextEditingController();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController eventDateController = TextEditingController();
  final TextEditingController eventTimeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

   @override
  void dispose() {
    orderItemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: .center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Text("Order Creation",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: .w600
                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: DropdownMenu<String>(
                    controller: orderItemController,
                    width: .infinity,
                    label: const Text("Order Item"),
                    initialSelection: orderItems.first,
                    onSelected: (value) {
                      setState(() {
                        selectedItem = value;
                      });
                    },
                    dropdownMenuEntries: orderItems
                      .map(
                        (item) => DropdownMenuEntry<String>(
                          value: item,
                          label: item,
                        ),
                      ).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: TextFormField(
                    controller: itemNameController,
                    decoration: const InputDecoration(
                      labelText: "Item Name",
                      hintText: "Enter item name",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.inventory_2_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Item name is required";
                      }

                      if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(value)) {
                        return "Special characters are not allowed";
                      }

                      return null;
                    },
                  ),
                ),
            
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: TextFormField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Quantity",
                      hintText: "Enter quantity",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.numbers),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Quantity is required";
                      }

                      if (!RegExp(r'^[1-9]\d*$').hasMatch(value)) {
                        return "Enter a valid whole number";
                      }

                      return null;
                    },
                  ),
                ),
            
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: TextFormField(
                    controller: customerNameController,
                    decoration: const InputDecoration(
                      labelText: "Customer Name",
                      hintText: "Enter customer name",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Customer name is required";
                      }

                      if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                        return "Only letters are allowed";
                      }

                      return null;
                    },
                  ),
                ),
            
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Customer Phone",
                      hintText: "Enter phone number",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone_outlined),
                      counterText: "",
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Phone number is required";
                      }

                      if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                        return "Phone number must be exactly 10 digits";
                      }

                      return null;
                    },
                  ),
                ),
            
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: TextFormField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      labelText: "Event Location",
                      hintText: "Enter event location",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Location is required";
                      }

                      if (!RegExp(r'^[a-zA-Z0-9 ,.-]+$').hasMatch(value)) {
                        return "Invalid location";
                      }

                      return null;
                    },
                  ),
                ),
            
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: TextFormField(
                    controller: eventDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Event Date",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select an event date";
                      }
                      return null;
                    },
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2035),
                      );
            
                      if (picked != null) {
                        eventDateController.text =
                            "${picked.day}/${picked.month}/${picked.year}";
                      }
                    },
                  ),
                ),
            
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: TextFormField(
                    controller: eventTimeController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Event Time",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.access_time),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select an event time";
                      }
                      return null;
                    },
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
            
                      if (picked != null) {
                        eventTimeController.text = picked.format(context);
                      }
                    },
                  ),
                ),
            
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: TextFormField(
                    controller: notesController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: "Notes (Optional)",
                      hintText: "Additional instructions",
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(bottom: 60),
                        child: Icon(Icons.notes_outlined),
                      ),
                    ),
                  ),
                ),
            
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: Selector<OrderViewModel, bool>(
                      selector: (_, vm) => vm.isLoading,
                      builder: (context, isLoading, child) {
                        return ElevatedButton.icon(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }

                                  if (selectedItem == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Please select an order item"),
                                      ),
                                    );
                                    return;
                                  }

                                  final success =
                                      await context.read<OrderViewModel>().createOrder(
                                            orderItem: selectedItem!,
                                            itemName: itemNameController.text.trim(),
                                            quantity:
                                                int.parse(quantityController.text.trim()),
                                            customerName:
                                                customerNameController.text.trim(),
                                            phone: phoneController.text.trim(),
                                            location: locationController.text.trim(),
                                            eventDate: eventDateController.text,
                                            eventTime: eventTimeController.text,
                                            notes: notesController.text.trim(),
                                            status: 0,
                                          );

                                  if (!context.mounted) return;

                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Order Created Successfully"),
                                      ),
                                    );

                                    _formKey.currentState!.reset();

                                    itemNameController.clear();
                                    quantityController.clear();
                                    customerNameController.clear();
                                    phoneController.clear();
                                    locationController.clear();
                                    eventDateController.clear();
                                    eventTimeController.clear();
                                    notesController.clear();

                                    setState(() {
                                      selectedItem = null;
                                    });
                                  }
                                },
                          icon: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.save_outlined),
                          label: Text(
                            isLoading ? "Saving..." : "Save Order",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}