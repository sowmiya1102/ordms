import 'package:flutter/material.dart';
import 'package:ordms/data/models/create_order_model.dart';
import 'package:ordms/view/orders/create_order.dart';
import 'package:ordms/viewmodels/order_view_model.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

  bool isSearch = false;

  @override
  void initState() {
    super.initState();

     WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderViewModel>().getOrdersList();
    });

    // Future.microtask(() {
    //   context.read<OrderViewModel>().getOrdersList();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Text(
                      "Orders",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
      
                    const Spacer(),
      
                    if (!isSearch)
                      Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            PopupMenuButton<String>(
                              icon: const Icon(
                                Icons.filter_alt_outlined,
                                color: Colors.white,
                              ),
                              onSelected: (value) {
                                context.read<OrderViewModel>().selectCategory(value);
                              },
                              itemBuilder: (context) => const [
                                PopupMenuItem(
                                  value: "All",
                                  child: Text("All"),
                                ),
                                PopupMenuItem(
                                  value: "Lights",
                                  child: Text("Lights"),
                                ),
                                PopupMenuItem(
                                  value: "Tents",
                                  child: Text("Tents"),
                                ),
                                PopupMenuItem(
                                  value: "Chairs",
                                  child: Text("Chairs"),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.search, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  isSearch = true;
                                });
                              },
                            ),
                          ],
                        ),
                      )
                    else
                      Expanded(
                        child: TextField(
                          controller: context.read<OrderViewModel>().searchController,
                          autofocus: true,
                          style: const TextStyle(
                            color: Colors.black, // Text color
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            hintText: "Search",
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                            filled: true,
                            fillColor: Colors.white, // Background color
      
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
      
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
      
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.blue, // Border when focused
                                width: 1,
                              ),
                            ),
      
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                context.read<OrderViewModel>().searchController.clear();
                                context.read<OrderViewModel>().filterOrder();
      
                                setState(() {
                                  isSearch = false;
                                });
                              },
                            ),
                          ),
                          onChanged: (_) {
                            context.read<OrderViewModel>().filterOrder();
                          },
                        ),
                      )
                  ],
                )
              ),
              // const SizedBox(height: 10,),
              // Consumer<OrderViewModel>(
              //   builder: (context, vm, child) {
              //     return Wrap(
              //       spacing: 10,
              //       children: List.generate(vm.categories.length, (index) {
              //         return CategoryChip(
              //           title: vm.categories[index],
              //           isSelected: vm.selectedIndex == index,
              //           onTap: () {
              //             vm.selectStatus(index);
              //           },
              //         );
              //       }),
              //     );
              //   },
              // ),
              const SizedBox(height: 20,),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Consumer<OrderViewModel>(
                    builder: (context, ordVM, child) {
                      if(ordVM.isLoading1) {
                        return Center(child: CircularProgressIndicator(strokeWidth: 1.0,));
                      }
      
                      if (ordVM.orderFilterList.isEmpty) {
                        return const Center(
                          child: Text(
                            "No Orders Found",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }
      
                      return ListView.builder(
                        itemCount: ordVM.orderFilterList.length,
                        itemBuilder: (context, index) {
                          final orders = ordVM.orderFilterList[index];
                        
                          return Container(
                            margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: .start,
                                        crossAxisAlignment: .start,
                                        children: [
                                          Text(orders.customerName,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: .w600
                                          ),
                                          ),
                                          const SizedBox(height: 4,),
                                          Text('${orders.quantity} ${orders.itemName}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: .w600
                                          ),),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: 140,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: .circular(20)
                                          ),
                                          child: Text(
                                            orders.eventDate,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                            textAlign: .center,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          width: 140,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: orders.ordStatus == "pending" ? Colors.amber
                                            : orders.ordStatus == "completed" ? Colors.green
                                            : Colors.red,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            orders.ordStatus,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: .w600
                                            ),
                                            textAlign: .center,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 8,),
                                    PopupMenuButton<String>(
                                      // onSelected: (value) {
                                      //   if (value == 'edit') {
                                      //     // Edit action
                                      //   } else if (value == 'delete') {
                                      //     // Delete action
                                      //   }
                                      // },
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: 'edit',
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => CreateOrder(isEdit: true, id: orders.id,)),
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Icon(Icons.edit, size: 20),
                                                SizedBox(width: 8),
                                                Text('Edit'),
                                              ],
                                            ),
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 'delete',
                                          child: InkWell(
                                            onTap: () async {
                                              Navigator.pop(context);
                                              await showDialog(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title: const Text("Delete Order"),
                                                  content: const Text("Do You really want to delete this order?"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(ctx).pop();
                                                      },
                                                      child: const Text("No"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        Navigator.pop(ctx);
      
                                                        await context
                                                            .read<OrderViewModel>()
                                                            .deleteOrder(orders.id!);
      
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(
                                                            content: Text("Order deleted successfully"),
                                                          ),
                                                        );
                                                      },
                                                      child: const Text("Yes"),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Icon(Icons.delete, color: Colors.red, size: 20),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Delete',
                                                  style: TextStyle(color: Colors.red),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                      child: const Icon(Icons.more_vert),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  ),
                ),
              ),
            ],
          )
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateOrder()),
            );
          },
          icon: Icon(Icons.add, color: Colors.white,),
          label: Text("Create Order"),
        ),
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}