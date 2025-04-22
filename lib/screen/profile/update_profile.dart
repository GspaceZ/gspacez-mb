import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:untitled/screen/auth/widgets/input_decoration.dart';
import 'package:untitled/screen/validators/index.dart';
import 'package:untitled/view_model/update_profile_view_model.dart';
import '../../router/app_router.dart';

class UpdateProfile extends StatelessWidget {
  const UpdateProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Profile"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: ChangeNotifierProvider(
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
                      child: Column(
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
                              controller: viewModel.dateOfBirthController,
                              decoration: CusTomInputDecoration(
                                  FlutterI18n.translate(
                                      context, "profile.dob"))
                                  .getInputDecoration()
                                  .copyWith(
                                suffixIcon:
                                const Icon(Icons.calendar_month),
                              ),
                              onTap: () async {
                                FocusScope.of(context).requestFocus(
                                    FocusNode()); // to prevent opening default keyboard
                                final DateTime? pickedDate =
                                await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.tryParse(viewModel.dateOfBirthController.text) ?? DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (pickedDate != null) {
                                  viewModel.dateOfBirthController.text =
                                      pickedDate.toIso8601String().substring(
                                          0, 10); // format: yyyy-mm-dd
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: viewModel.isLoadingCountries
                                ? const CircularProgressIndicator()
                                : DropdownButtonFormField<String>(
                              value: viewModel.nationController.text.isNotEmpty
                                  ? viewModel.nationController.text
                                  : null,
                              isExpanded: true,
                              decoration: CusTomInputDecoration(
                                FlutterI18n.translate(context, "profile.country"),
                              ).getInputDecoration(),
                              items: viewModel.countries.map((country) {
                                return DropdownMenuItem(
                                  value: country.name,
                                  child: Row(
                                    children: [
                                      SvgPicture.network(
                                        country.flag,
                                        width: 24,
                                        height: 16,
                                        placeholderBuilder: (context) => const SizedBox(
                                          width: 24,
                                          height: 16,
                                          child: CircularProgressIndicator(strokeWidth: 1),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          country.name,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: viewModel.isEdit
                                  ? (value) {
                                if (value != null) {
                                  viewModel.updateCountry(value);
                                }
                              }
                                  : null,
                              validator: (value) =>
                                  InputDefaultValidator.validate(value ?? ''),
                              disabledHint: viewModel.nationController.text.isNotEmpty
                                  ? Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      viewModel.nationController.text,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              )
                                  : null,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: viewModel.descriptionController,
                              decoration: CusTomInputDecoration(
                                FlutterI18n.translate(context, "profile.description"),
                              ).getInputDecoration(),
                              validator: (value) =>
                                  InputDefaultValidator.validate(value!),
                              enabled: viewModel.isEdit,
                              maxLines: viewModel.isEdit ? 5 : null,
                              minLines: 3,
                              style: (viewModel.isEdit)
                                  ? const TextStyle()
                                  : const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              readOnly: !viewModel.isEdit,
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
                                      viewModel.isEdit ? "Save" : "Edit",
                                      style:
                                          const TextStyle(color: Colors.white),
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
                                          borderRadius:
                                              BorderRadius.circular(16),
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
      ),
    );
  }
}
