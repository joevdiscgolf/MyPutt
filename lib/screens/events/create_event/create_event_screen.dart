import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/cubits/events/events_cubit.dart';
import 'package:myputt/data/types/challenges/generated_challenge_item.dart';
import 'package:myputt/data/types/events/event_enums.dart';
import 'package:myputt/screens/events/create_event/forms/date_layout_form.dart';
import 'package:myputt/screens/events/create_event/forms/name_description_form.dart';
import 'package:myputt/screens/events/create_event/forms/event_details_form.dart';
import 'package:myputt/utils/challenge_helpers.dart';
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
  List<GeneratedChallengeInstruction> _challengeInstructions = [];

  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;

  ButtonState _buttonState = ButtonState.normal;

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
      NameDescriptionForm(
        eventNameController: _eventNameController,
        eventDescriptionController: _descriptionController,
      ),
      EventDetailsForm(
        selectedDivisions: _selectedDivisions,
        signatureVerification: _signatureVerification,
        instructions: _challengeInstructions,
        onDivisionSelected: (List<Division> divisions) =>
            setState(() => _selectedDivisions = divisions),
        updateSignatureVerification: (bool verifySignature) =>
            setState(() => _signatureVerification = verifySignature),
        updateChallengeInstructions:
            (List<GeneratedChallengeInstruction> instructions) =>
                setState(() => _challengeInstructions = instructions),
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
            buttonState: _buttonState,
            text: _currentPage == 2 ? 'Submit' : 'Continue',
            onPressed: () async {
              if (!validateInputs()) {
                return;
              }
              if (_currentPage == 2) {
                if (!_validateSubmit()) {
                  return;
                }
                setState(() => _errorText = null);
                setState(() => _buttonState = ButtonState.loading);
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
                  challengeStructure: challengeStructureFromInstructions(
                      _challengeInstructions),
                );
                setState(() => _buttonState =
                    createSuccess ? ButtonState.success : ButtonState.retry);
                if (createSuccess) {
                  await Future.delayed(const Duration(milliseconds: 500),
                      () => Navigator.of(context).pop());
                } else {
                  setState(() =>
                      _errorText = 'Failed to create event. Please try again');
                }
              } else if (validateInputs()) {
                _nextPage();
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
              _buttonState = ButtonState.normal;
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
        if (_eventNameController.text.isEmpty) {
          setState(() => _errorText = 'Enter an event name');
        }
        return _eventNameController.text.isNotEmpty;
      case 1:
        if (_selectedDivisions.isEmpty) {
          setState(() => _errorText = 'Enter divisions');
        } else if (_challengeInstructions.isEmpty) {
          setState(() => _errorText = 'Enter an event layout');
        }
        return _selectedDivisions.isNotEmpty &&
            _challengeInstructions.isNotEmpty;
      case 2:
        if (_startDate == null) {
          setState(() => _errorText = 'Enter a start date');
        } else if (_endDate == null) {
          setState(() => _errorText = 'Enter an end date');
        }
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
      setState(() => _errorText = 'Please enter divisions');
      return false;
    } else if (_challengeInstructions.isEmpty) {
      setState(() => _errorText = 'Enter an event layout');
    } else if (_startDate == null) {
      setState(() => _errorText = 'Please enter a start date');
      return false;
    } else if (_endDate == null) {
      setState(() => _errorText = 'Please enter an end date');
      return false;
    }
    return true;
  }
}
