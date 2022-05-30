import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/cubits/events/events_cubit.dart';
import 'package:myputt/data/types/events/event_enums.dart';
import 'package:myputt/screens/events/create_event/forms/date_layout_form.dart';
import 'package:myputt/screens/events/create_event/forms/event_basic_info_form.dart';
import 'package:myputt/screens/events/create_event/forms/event_details_form.dart';
import 'package:myputt/utils/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'components/buttons.dart';
import 'components/create_event_header.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({Key? key}) : super(key: key);

  static String routeName = '/create_event_screen';

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String? _errorText;

  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _eventName;
  String? _eventDescription;

  List<Division> _selectedDivisions = [];
  bool _signatureVerification = true;

  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;

  bool _loading = false;

  @override
  void initState() {
    _eventNameController.addListener(() {
      if (_eventNameController.text.isNotEmpty) {
        setState(() => _eventName = _eventNameController.text);
      }
    });
    _descriptionController.addListener(() {
      if (_descriptionController.text.isNotEmpty) {
        setState(() => _eventDescription = _descriptionController.text);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: GestureDetector(
        onTap: () {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.white,
            shadowColor: Colors.transparent,
            leading: IconButton(
              color: Colors.transparent,
              icon: const Icon(
                FlutterRemix.arrow_left_s_line,
                color: Colors.black,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: CreateEventHeader(),
              ),
              const SizedBox(
                height: 24,
              ),
              Expanded(child: _carouselBody(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _carouselBody(BuildContext context) {
    final bool addBottomPadding = MediaQuery.of(context).viewPadding.bottom > 0;
    List<Widget> carouselChildren = [
      EventBasicInfoForm(
        eventNameController: _eventNameController,
        eventDescriptionController: _descriptionController,
      ),
      EventDetailsForm(
        selectedDivisions: _selectedDivisions,
        signatureVerification: _signatureVerification,
        onDivisionSelected: (List<Division> divisions) =>
            setState(() => _selectedDivisions = divisions),
        updateSignatureVerification: (bool verifySignature) =>
            setState(() => _signatureVerification = verifySignature),
      ),
      DateLayoutForm(
        onSelectStartDate: (DateTime startDate) =>
            setState(() => _startDate = startDate),
        onSelectStartTime: (TimeOfDay startTime) =>
            setState(() => _startTime = startTime),
        onSelectEndDate: (DateTime endDate) =>
            setState(() => _endDate = endDate),
        onSelectEndTime: (TimeOfDay endTime) =>
            setState(() => _endTime = endTime),
      ),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: PageView(
            allowImplicitScrolling: false,
            controller: _pageController,
            onPageChanged: (int page) {
              if (page != _currentPage) {
                _currentPage = page;
              }
            },
            children: carouselChildren,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ),
        SizedBox(
          height: 16,
          child: _errorText == null
              ? null
              : Text(
                  _errorText!,
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: MyPuttColors.red,
                        fontSize: 14,
                      ),
                ),
        ),
        const SizedBox(
          height: 16,
        ),
        SmoothPageIndicator(
          controller: _pageController,
          count: 3,
          effect: ExpandingDotsEffect(
            activeDotColor: MyPuttColors.darkGray,
            dotColor: MyPuttColors.gray[200]!,
            dotHeight: 6,
            dotWidth: 6,
            spacing: 4,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ContinueButton(
            loading: _loading,
            text: _currentPage == 2 ? 'Submit' : 'Continue',
            onPressed: () async {
              if (_currentPage == 2) {
                setState(() => _errorText = null);
                if (!_validateSubmit()) {
                  return;
                }
                setState(() => _loading = true);
                final bool createSuccess =
                    await BlocProvider.of<EventsCubit>(context)
                        .createEventRequest(
                  eventName: _eventName!,
                  eventDescription: _eventDescription,
                  verificationSignature: _signatureVerification,
                  divisions: _selectedDivisions,
                  startDate: _startDate!,
                  startTime: _startTime,
                  endDate: _endDate!,
                  endTime: _endTime,
                  challengeStructure: [],
                );
                setState(() => _loading = false);
                if (!createSuccess) {
                  setState(() =>
                      _errorText = 'Failed to create event. Please try again');
                  return;
                }
                Navigator.of(context).pop();
              } else if (validateInputs()) {
                _nextPage();
              } else {
                setState(() => _errorText = 'Please fill all required fields');
              }
            },
          ),
        ),
        const SizedBox(width: 16),
        PreviousPageButton(
          onTap: () {
            if (_currentPage == 0) {
              return;
            }
            setState(() {
              _currentPage--;
              _errorText = null;
            });
            _pageController.animateToPage(
              _currentPage,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeIn,
            );
          },
        ),
        SizedBox(height: addBottomPadding ? 32 : 12),
      ],
    );
  }

  bool validateInputs() {
    switch (_currentPage) {
      case 0:
        return _eventNameController.text.isNotEmpty;
      case 1:
        return _selectedDivisions.isNotEmpty;
      case 2:
        return _startDate != null && _endDate != null;
      default:
        return false;
    }
  }

  void _nextPage() {
    if (_currentPage < 2) {
      setState(() {
        _currentPage++;
        _errorText = null;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeIn,
      );
    }
  }

  bool _validateSubmit() {
    if (_eventName == null) {
      setState(() => _errorText = 'Please enter an event name');
      return false;
    } else if (_selectedDivisions.isEmpty) {
      setState(() => _errorText = 'Please enter an event format structure');
      return false;
    } else if (_startDate == null) {
      setState(() => _errorText = 'Please enter an start date');
      return false;
    } else if (_endDate == null) {
      setState(() => _errorText = 'Please enter an end date');
      return false;
    }
    return true;
  }
}
