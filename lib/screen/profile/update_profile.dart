import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:untitled/screen/auth/widgets/input_decoration.dart';
import 'package:untitled/screen/validators/index.dart';
import 'package:untitled/view_model/update_profile_view_model.dart';
import '../../router/app_router.dart';

class UpdateProfile extends StatelessWidget {
  const UpdateProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => UpdateProfileViewModel(),
      child: Consumer<UpdateProfileViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: NetworkImage(viewModel.pathAvatar),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.updateAvatar);
                            },
                            child: Text(
                              FlutterI18n.translate(
                                  context, "profile.choose_avatar"),
                              style: const TextStyle(color: Colors.blue),
                            )),
                      ],
                    ),
                  ),
                  Form(
                    key: viewModel.formKey,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: viewModel.firstNameController,
                                  decoration: CusTomInputDecoration(
                                          FlutterI18n.translate(
                                              context, "auth.first_name"))
                                      .getInputDecoration(),
                                  validator: (value) =>
                                      FirstnameValidator.validate(value!),
                                  enabled: viewModel.isEdit,
                                  style: (viewModel.isEdit)
                                      ? const TextStyle()
                                      : const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Optional: to give some space between the fields
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: viewModel.lastNameController,
                                  decoration: CusTomInputDecoration(
                                          FlutterI18n.translate(
                                              context, "auth.last_name"))
                                      .getInputDecoration(),
                                  validator: (value) =>
                                      LastnameValidator.validate(value!),
                                  enabled: viewModel.isEdit,
                                  style: (viewModel.isEdit)
                                      ? const TextStyle()
                                      : const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: viewModel.nationController,
                            decoration: CusTomInputDecoration(
                                    FlutterI18n.translate(
                                        context, "profile.country"))
                                .getInputDecoration(),
                            validator: (value) =>
                                InputDefaultValidator.validate(value!),
                            enabled: viewModel.isEdit,
                            style: (viewModel.isEdit)
                                ? const TextStyle()
                                : const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: viewModel.cityController,
                            decoration: CusTomInputDecoration(
                                    FlutterI18n.translate(
                                        context, "profile.city"))
                                .getInputDecoration(),
                            validator: (value) =>
                                InputDefaultValidator.validate(value!),
                            enabled: viewModel.isEdit,
                            style: (viewModel.isEdit)
                                ? const TextStyle()
                                : const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: viewModel.addressController,
                            decoration: CusTomInputDecoration(
                              FlutterI18n.translate(context, "profile.address"),
                            ).getInputDecoration(),
                            validator: (value) =>
                                InputDefaultValidator.validate(value!),
                            enabled: viewModel.isEdit,
                            style: (viewModel.isEdit)
                                ? const TextStyle()
                                : const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: viewModel.dateOfBirthController,
                            decoration: CusTomInputDecoration(
                                    FlutterI18n.translate(
                                        context, "profile.dob"))
                                .getInputDecoration()
                                .copyWith(
                                  suffixIcon: const Icon(Icons.calendar_month),
                                ),
                            onTap: () async {
                              FocusScope.of(context).requestFocus(
                                  FocusNode()); // to prevent opening default keyboard
                              final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (pickedDate != null) {
                                viewModel.dateOfBirthController.text =
                                    pickedDate
                                        .toIso8601String()
                                        .substring(0, 10); // format: yyyy-mm-dd
                              }
                            },
                            enabled: viewModel.isEdit,
                            style: (viewModel.isEdit)
                                ? const TextStyle()
                                : const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                if (viewModel.isEdit) {
                                  viewModel.submit();
                                }
                                viewModel.changeIsEdit();
                              },
                              child: Container(
                                width: 130,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.blue),
                                child: Center(
                                  child: Text(
                                    FlutterI18n.translate(
                                        context,
                                        (viewModel.isEdit)
                                            ? "profile.save"
                                            : "profile.edit"),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            if (viewModel.isEdit)
                              TextButton(
                                onPressed: () {
                                  viewModel.changeIsEdit(newValue: false);
                                },
                                child: Container(
                                    width: 130,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                            width: 1.5,
                                            color: Colors.blue.shade400),
                                        color: Colors.white),
                                    child: Center(
                                        child: Text(
                                            FlutterI18n.translate(
                                                context, "profile.cancel"),
                                            style: const TextStyle(
                                                color: Colors.blue)))),
                              )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
