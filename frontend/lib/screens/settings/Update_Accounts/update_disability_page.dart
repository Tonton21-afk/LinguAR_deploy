import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingua_arv1/bloc/Change_disability/change_disability_bloc.dart';
import 'package:lingua_arv1/validators/token.dart';

Future<void> showUpdateDisabilityModal(BuildContext context) async {
  String? selectedDisability;

  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext ctx) {
      return BlocConsumer<ChangeDisabilityBloc, ChangeDisabilityState>(
        listener: (context, state) async {
          if (state is ChangeDisabilitySuccess) {
            await TokenService.saveDisability(state.disability);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Disability updated successfully")),
            );
            Navigator.pop(context, true); 
          }
        },
        builder: (context, state) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Select Disability",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ...["None", "Mute", "Deaf", "Blind"].map((option) {
                      return RadioListTile<String>(
                        title: Text(option),
                        value: option,
                        groupValue: selectedDisability,
                        onChanged: (value) {
                          setState(() {
                            selectedDisability = value;
                          });
                        },
                      );
                    }).toList(),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: selectedDisability == null
                          ? null
                          : () async {
                              final userId = await TokenService.getUserId();
                              if (userId == null || userId.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Error: User ID not found. Please log in again."),
                                  ),
                                );
                                return;
                              }

                              context.read<ChangeDisabilityBloc>().add(
                                    UpdateDisabilityEvent(
                                      userId: userId,
                                      disability: selectedDisability == "None"
                                          ? null
                                          : selectedDisability,
                                    ),
                                  );
                            },
                      child: state is ChangeDisabilityLoading
                          ? const CircularProgressIndicator()
                          : const Text("Confirm"),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    },
  );
}
