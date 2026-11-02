import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DrBayMax',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff9f5d65)),
        fontFamily: 'Arial',
        useMaterial3: true,
      ),
      home: const SignupPage(),
    );
  }
}

const _background = Color(0xffe6d1d1);
const _ink = Color(0xff2e2022);

class BaymaxIllustration extends StatefulWidget {
  const BaymaxIllustration({
    super.key,
    this.compact = false,
    this.assetPath = 'assets/images/baymax.png',
    this.floating = false,
  });

  final bool compact;
  final String assetPath;
  final bool floating;

  @override
  State<BaymaxIllustration> createState() => _BaymaxIllustrationState();
}

class _BaymaxIllustrationState extends State<BaymaxIllustration>
    with SingleTickerProviderStateMixin {

  late final AnimationController _breathingController;

  @override
  void initState() {
    super.initState();

    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.compact ? 300.0 : 500.0;

    // Respect the device's reduced-animation setting.
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return SizedBox(
      height: size,
      width: size,
      child: AnimatedBuilder(
        animation: _breathingController,
        builder: (context, child) {

          // Keep Baymax still if reduced motion is enabled.
          final progress = reduceMotion
              ? 0.0
              : Curves.easeInOut.transform(
                  _breathingController.value,
                );

          // Very subtle expansion and contraction.
          final scale = 1.0 + (progress * 0.012);

          // Gentle floating, only when requested.
          final verticalOffset = widget.floating && !reduceMotion
              ? (progress * 4.0) - 2.0
              : 0.0;

          return Transform.translate(
            offset: Offset(0, verticalOffset),
            child: Transform.scale(
              scale: reduceMotion ? 1.0 : scale,
              child: child,
            ),
          );
        },
        child: Image.asset(
          widget.assetPath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
const pink = Color(0xFFE5CCCC);
const pinkLight = Color(0xFFFFF5F1);
const sage = Color(0xFFC5D0B4);
const sageDark = Color(0xFF71845F);
const ink = Color(0xFF302A2A);
const muted = Color(0xFF756D6D);

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();
  final username = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();
  bool hidePassword = true, hideConfirm = true;

  @override
  void dispose() {
    username.dispose(); password.dispose(); confirm.dispose(); super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: pink,
    body: SafeArea(child: Center(child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 430),
        child: Form(key: formKey, child: Column(children: [
          const Brand(),
          const SizedBox(height: 20),
          const Text('Create your account', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: ink)),
          const SizedBox(height: 6),
          const Text('A calmer space starts with you.', style: TextStyle(color: muted)),
          const SizedBox(height: 22),
          AppTextField(label: 'Username', hint: 'Choose a username', controller: username,
            validator: (v) => v == null || v.trim().isEmpty ? 'Enter a username' : null),
          const SizedBox(height: 13),
          AppTextField(label: 'Password', hint: 'Create a password', controller: password,
            obscure: hidePassword, suffix: IconButton(
              onPressed: () => setState(() => hidePassword = !hidePassword),
              icon: Icon(hidePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined)),
            validator: (v) => v == null || v.length < 8 ? 'Use at least 8 characters' : null),
          const SizedBox(height: 13),
          AppTextField(label: 'Confirm Password', hint: 'Enter the password again', controller: confirm,
            obscure: hideConfirm, suffix: IconButton(
              onPressed: () => setState(() => hideConfirm = !hideConfirm),
              icon: Icon(hideConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined)),
            validator: (v) => v != password.text ? 'Passwords do not match' : null),
          const SizedBox(height: 20),
          PrimaryButton(label: 'Continue', onPressed: () {
            if (formKey.currentState!.validate()) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ConversationStep1Page()));
            }
          }),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
            child: const Text(
              'Already have an account? Log in',
              style: TextStyle(color: ink),
            ),
          ),
        ])),
      ),
    ))),
  );
}
class ConversationStep1Page extends StatefulWidget {
  const ConversationStep1Page({super.key});
  @override
  State<ConversationStep1Page> createState() => _ConversationStep1PageState();
}
class _ConversationStep1PageState extends State<ConversationStep1Page> {
  String feeling = 'A little anxious', duration = 'A few days', noticed = 'Recently', frequency = 'A few times a week';
  @override
  Widget build(BuildContext context) => OnboardingScaffold(
    step: 1, title: 'A Little About You',
    subtitle: "I'm here to support your well-being. Let's start with what brings you here.",
    buttonText: 'Continue',
    onContinue: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConversationStep2Page())),
    children: [
      Question(label: 'What would you like help with today?', value: feeling,
        options: const ['A little anxious', 'Feeling stressed', 'Feeling low', 'Sleep difficulties', 'Just checking in'],
        onChanged: (v) => setState(() => feeling = v)),
      Question(label: 'How long have you been experiencing this?', value: duration,
        options: const ['A few days', 'A few weeks', 'A few months', 'A long time', 'Not sure'],
        onChanged: (v) => setState(() => duration = v)),
      Question(label: 'When did you first notice these feelings?', value: noticed,
        options: const ['Recently', 'A few weeks ago', 'A few months ago', 'I cannot remember'],
        onChanged: (v) => setState(() => noticed = v)),
      Question(label: 'How often do these feelings affect your day?', value: frequency,
        options: const ['Rarely', 'A few times a week', 'Almost every day', 'Several times a day'],
        onChanged: (v) => setState(() => frequency = v)),
    ],
  );
}

class ConversationStep2Page extends StatefulWidget {
  const ConversationStep2Page({super.key});
  @override
  State<ConversationStep2Page> createState() => _ConversationStep2PageState();
}
class _ConversationStep2PageState extends State<ConversationStep2Page> {
  String diagnosis = 'Prefer not to say', support = 'Not currently', symptoms = 'Racing heart';
  @override
  Widget build(BuildContext context) => OnboardingScaffold(
    step: 2, title: 'A Little About Your Health',
    subtitle: "Thank you for sharing. These optional questions help BayMax understand your wellness needs.",
    buttonText: 'Continue',
    onContinue: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConversationStep3Page())),
    children: [
      Question(label: 'Have you ever received a mental health diagnosis from a healthcare professional?', value: diagnosis,
        options: const ['Yes', 'No', 'Prefer not to say'],
        onChanged: (v) => setState(() => diagnosis = v)),
      Question(label: 'Are you currently receiving professional support?', value: support,
        options: const ['Yes, regularly', 'Sometimes', 'Not currently', 'Prefer not to say'],
        onChanged: (v) => setState(() => support = v)),
      Question(label: 'Do you notice physical symptoms when stressed or anxious?', value: symptoms,
        options: const ['Racing heart', 'Feeling hot or sweating', 'Tense muscles', 'Stomach discomfort', 'Trouble sleeping', 'None of these'],
        onChanged: (v) => setState(() => symptoms = v)),
    ],
  );
}

class ConversationStep3Page extends StatefulWidget {
  const ConversationStep3Page({super.key});
  @override
  State<ConversationStep3Page> createState() => _ConversationStep3PageState();
}
class _ConversationStep3PageState extends State<ConversationStep3Page> {
  String trigger = 'Uncertainty or change', coping = 'Talking to someone', goal = 'Feel calmer';
  @override
  Widget build(BuildContext context) => OnboardingScaffold(
    step: 3, title: 'What Affects Your Mood?',
    subtitle: 'There are no right or wrong answers. Choose what feels closest to your experience.',
    buttonText: "Let's Start",
    onContinue: () => Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (_) => const WelcomePage()), (_) => false),
    children: [
      Question(label: 'When do you usually feel stressed or uncomfortable?', value: trigger,
        options: const ['Uncertainty or change', 'School or work', 'Social situations', 'Being alone', 'Health concerns', 'Not sure'],
        onChanged: (v) => setState(() => trigger = v)),
      Question(label: 'What helps you feel better?', value: coping,
        options: const ['Talking to someone', 'Listening to music', 'Breathing exercises', 'Walking or exercise', 'Resting', 'Still figuring it out'],
        onChanged: (v) => setState(() => coping = v)),
      Question(label: 'What would you most like help with?', value: goal,
        options: const ['Feel calmer', 'Understand my emotions', 'Improve my sleep', 'Manage stress', 'Build healthy routines'],
        onChanged: (v) => setState(() => goal = v)),
      Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white.withOpacity(.7), borderRadius: BorderRadius.circular(15)),
        child: const Text('💚 Thank you for sharing, Human. You are in control of what you choose to tell BayMax.', style: TextStyle(color: ink, height: 1.4))),
    ],
  );
}

class OnboardingScaffold extends StatelessWidget {
  final int step; final String title, subtitle, buttonText; final VoidCallback onContinue; final List<Widget> children;
  const OnboardingScaffold({super.key, required this.step, required this.title, required this.subtitle,
    required this.buttonText, required this.onContinue, required this.children});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: pink,
    body: SafeArea(child: Container(
      decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [Color(0xFFFFE9E5), pink, Color(0xFFF1DADA)])),
      child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(22, 18, 22, 25),
        child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 460),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Brand(compact: true),
            const SizedBox(height: 18),
            Row(children: [
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_rounded)),
              const SizedBox(width: 6),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('STEP $step OF 3', style: const TextStyle(color: sageDark, fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1.4)),
                const SizedBox(height: 6),
                ClipRRect(borderRadius: BorderRadius.circular(12), child: LinearProgressIndicator(value: step / 3, minHeight: 6, backgroundColor: Colors.white, color: sageDark)),
              ])),
            ]),
            const SizedBox(height: 17),
            Text(title, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800, color: ink)),
            const SizedBox(height: 7),
            Text(subtitle, style: const TextStyle(fontSize: 13, height: 1.4, color: muted)),
            const SizedBox(height: 20),
            ...children.map((child) => Padding(padding: const EdgeInsets.only(bottom: 13), child: child)),
            const SizedBox(height: 5),
            PrimaryButton(label: buttonText, onPressed: onContinue),
            const SizedBox(height: 12),
            const Text('This app supports wellness and does not replace professional medical care.',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: muted)),
          ]),
        )),
      ),
    )),
  );
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: pink,
    body: SafeArea(child: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(children: [
      const Brand(),
      const SizedBox(height: 28),
      const Mascot(height: 230),
      const SizedBox(height: 20),
      const Text('BayMax is ready!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: ink)),
      const SizedBox(height: 8),
      const Text("Your wellness journey starts with one small step. I'm here to listen, Human.",
        textAlign: TextAlign.center, style: TextStyle(color: muted, height: 1.5)),
      const SizedBox(height: 26),
      PrimaryButton(label: 'Open BayMax Chat', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DemoChatPage()))),
      const SizedBox(height: 12),
      OutlinedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DemoHistoryPage())),
        child: const Text('View Wellness History')),
    ])))),
  );
}

class DemoChatPage extends StatefulWidget {
  const DemoChatPage({super.key});
  @override
  State<DemoChatPage> createState() => _DemoChatPageState();
}
class _DemoChatPageState extends State<DemoChatPage> {
  final controller = TextEditingController();
  final messages = <String>["BayMax: Hello, Human! I'm here to listen. How are you feeling today?"];
  @override
  void dispose() { controller.dispose(); super.dispose(); }
  void send() {
    final text = controller.text.trim(); if (text.isEmpty) return;
    setState(() { messages.add('You: $text'); messages.add("BayMax: Thank you for telling me. Let's take this one step at a time."); controller.clear(); });
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Chat with BayMax'), backgroundColor: pink),
    backgroundColor: pinkLight,
    body: Column(children: [
      Expanded(child: ListView(padding: const EdgeInsets.all(16), children: [
        for (final message in messages) Align(alignment: message.startsWith('You:') ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(13),
            constraints: const BoxConstraints(maxWidth: 310),
            decoration: BoxDecoration(color: message.startsWith('You:') ? sage : Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Text(message))),
        Wrap(spacing: 7, children: [
          ActionChip(label: const Text('I feel anxious'), onPressed: () { controller.text = 'I feel anxious'; send(); }),
          ActionChip(label: const Text('Help me relax'), onPressed: () { controller.text = 'Help me relax'; send(); }),
        ]),
      ])),
      Padding(padding: const EdgeInsets.all(12), child: Row(children: [
        Expanded(child: TextField(controller: controller, onSubmitted: (_) => send(), decoration: InputDecoration(hintText: 'Type your message...', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none)))),
        IconButton(onPressed: send, icon: const Icon(Icons.send_rounded, color: sageDark)),
      ])),
    ]),
  );
}

class DemoHistoryPage extends StatelessWidget {
  const DemoHistoryPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Wellness History'), backgroundColor: pink),
    backgroundColor: pink,
    body: ListView(padding: const EdgeInsets.all(18), children: const [
      MetricTile(icon: Icons.psychology_alt_rounded, title: 'Anxiety Episodes', value: '4'),
      MetricTile(icon: Icons.sentiment_satisfied_alt_rounded, title: 'Mood Summary', value: 'Good'),
      MetricTile(icon: Icons.speed_rounded, title: 'Average Stress', value: '5.2/10'),
      MetricTile(icon: Icons.bedtime_rounded, title: 'Sleep', value: '6.4 hours'),
    ]),
  );
}
class MetricTile extends StatelessWidget {
  final IconData icon; final String title, value;
  const MetricTile({super.key, required this.icon, required this.title, required this.value});
  @override
  Widget build(BuildContext context) => Card(color: sage, child: ListTile(leading: Icon(icon, color: sageDark), title: Text(title), trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.w800))));
}

class Brand extends StatelessWidget {
  final bool compact;
  const Brand({super.key, this.compact = false});
  @override
  Widget build(BuildContext context) => Column(children: [
    Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.favorite_border_rounded, color: sageDark, size: compact ? 27 : 36),
      const SizedBox(width: 7),
      Text('DrBayMax', style: TextStyle(color: const Color(0xFF573B3B), fontSize: compact ? 25 : 31, fontWeight: FontWeight.w500, letterSpacing: -0.8)),
    ]),
    const Text('Understand Your Feelings. Find Your Calm.', style: TextStyle(color: ink, fontSize: 10)),
  ]);
}

class Mascot extends StatelessWidget {
  final double height;

  const Mascot({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Container(
            width: height * 0.78,
            height: height * 0.78,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
          ),

          // BayMax head
          Positioned(
            top: height * 0.08,
            child: Container(
              width: height * 0.4,
              height: height * 0.25,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(height * 0.14),
                boxShadow: [
                  BoxShadow(
                    color: ink.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: height * 0.29,
                  height: height * 0.07,
                  decoration: BoxDecoration(
                    color: const Color(0xFF292D32),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MascotEye(),
                      MascotEye(),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // BayMax body
          Positioned(
            top: height * 0.34,
            child: Container(
              width: height * 0.48,
              height: height * 0.48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(height * 0.2),
                boxShadow: [
                  BoxShadow(
                    color: ink.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.favorite_rounded,
                color: sageDark,
                size: height * 0.17,
              ),
            ),
          ),

          // Left leg
          Positioned(
            bottom: height * 0.02,
            left: height * 0.17,
            child: Container(
              width: height * 0.12,
              height: height * 0.32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),

          // Right leg
          Positioned(
            bottom: height * 0.02,
            right: height * 0.17,
            child: Container(
              width: height * 0.12,
              height: height * 0.32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MascotEye extends StatelessWidget {
  const MascotEye({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

class AppTextField extends StatelessWidget {
  final String label, hint; final TextEditingController controller; final bool obscure; final Widget? suffix; final String? Function(String?)? validator;
  const AppTextField({super.key, required this.label, required this.hint, required this.controller, this.obscure = false, this.suffix, this.validator});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: const TextStyle(color: ink, fontSize: 12, fontWeight: FontWeight.w700)),
    const SizedBox(height: 6),
    TextFormField(controller: controller, obscureText: obscure, validator: validator, style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(fontSize: 12, color: muted), suffixIcon: suffix,
        filled: true, fillColor: Colors.white, contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: sageDark, width: 1.4)))),
  ]);
}

class Question extends StatelessWidget {
  final String label, value; final List<String> options; final ValueChanged<String> onChanged;
  const Question({super.key, required this.label, required this.value, required this.options, required this.onChanged});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.fromLTRB(13, 12, 12, 8),
    decoration: BoxDecoration(color: Colors.white.withOpacity(.73), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white.withOpacity(.8))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: ink, fontSize: 12, fontWeight: FontWeight.w600, height: 1.35)),
      const SizedBox(height: 7),
      DropdownButtonFormField<String>(value: value, isExpanded: true, style: const TextStyle(color: ink, fontSize: 12),
        decoration: InputDecoration(filled: true, fillColor: const Color(0xFFFFFEFC), contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: BorderSide.none)),
        items: options.map((option) => DropdownMenuItem(value: option, child: Text(option, overflow: TextOverflow.ellipsis))).toList(),
        onChanged: (v) { if (v != null) onChanged(v); }),
    ]),
  );
}

class PrimaryButton extends StatelessWidget {
  final String label; final VoidCallback onPressed;
  const PrimaryButton({super.key, required this.label, required this.onPressed});
  @override
  Widget build(BuildContext context) => SizedBox(width: double.infinity, child: FilledButton(
    onPressed: onPressed,
    style: FilledButton.styleFrom(backgroundColor: const Color(0xFF302D2D), foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
    child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
  ));
}



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _username = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                children: [
                  const Brand(),
                  const SizedBox(height: 36),
                  _field('Username', 'Username', _username),
                  const SizedBox(height: 18),
                  _field('Password', 'Password', _password, obscure: true),
                  const SizedBox(height: 22),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const HomePage()),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: _ink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    ),
                    child: const Text('Meet Your DrBayMax', style: TextStyle(fontSize: 12)),
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('✦', style: TextStyle(color: Color(0xfff5e98d), fontSize: 30)),
                      Text('✦', style: TextStyle(color: Color(0xfff5e98d), fontSize: 22)),
                    ],
                  ),
                  Transform.translate(
                  offset: const Offset(0, -40),
                  child:                   Transform.translate(
                    offset: const Offset(0, -80),
                    child: const IgnorePointer(
                      child: BaymaxIllustration(),
                    ),
                  ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(String label, String hint, TextEditingController controller, {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: _ink, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 11, color: Color(0xff777070)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: IndexedStack(
          index: _tab,
          children: const [HomeContent(), ProfilePage()],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (index) => setState(() => _tab = index),
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xffead9da),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}


class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(26, 34, 26, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: Brand()),

          const SizedBox(height: 32),

          const Text(
            "Baymax is ready! What's your\nnext adventure, Human?",
            style: TextStyle(
              color: _ink,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            child: const BaymaxIllustration(
              assetPath: 'assets/images/baymax_home.png',
              floating: true,
            ),
          ),

          const SizedBox(height: 24),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [


              ActionChip(
                avatar: const Icon(
                  Icons.medical_information_outlined,
                  size: 20,
                ),
                label: const Text('Clinical History'),

                onPressed: () => Navigator.of(context).pushReplacement(
                   MaterialPageRoute(builder: (_) => const HistoryPage()),
                ),


                backgroundColor: Colors.white,
                side: BorderSide.none,
              ),

              ActionChip(
                avatar: const Icon(
                  Icons.chat_bubble_outline,
                  size: 20,
                ),
                label: const Text('Chat with BayMax'),
                onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const BayMaxChatPage()),
                ),
                backgroundColor: Colors.white,
                side: BorderSide.none,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
// Use your existing _ink color and Brand widget.

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const Color _popupGreen = Color(0xFFDDE3CF);
  static const Color _buttonColor = Color(0xFF2D2D2D);
  static const Color _ink = Color(0xFF292929);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(26, 34, 26, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: Brand()),

          const SizedBox(height: 22),

          Row(
            children: [
              _roundIconButton(
                   icon: Icons.arrow_back_rounded,
                   onTap: () {
                   Navigator.of(context).pushReplacement(
                   MaterialPageRoute(
                           builder: (_) => const HomePage(),
                   ),
              );},),
              const Spacer(),
              const CircleAvatar(
                radius: 42,
                backgroundColor: Color(0xffc7c7c7),
                child: Icon(
                  Icons.person,
                  size: 62,
                  color: Color(0xff8b8b8b),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined, color: _ink),
              ),
            ],
          ),

          const SizedBox(height: 28),

          const Text(
            'A Little Thought from\nBaymax',
            style: TextStyle(
              color: _ink,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            '"Hey, Human! You spend so much time caring about everything else. Remember to save a little kindness for yourself, too."',
            style: TextStyle(
              color: _ink,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),

          const SizedBox(height: 32),

          // Add Emergency Contact button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                _showEmergencyContactDialog(context);
              },
              icon: const Icon(Icons.contact_phone_outlined),
              label: const Text('Add Emergency Contact'),
              style: _buttonStyle(),
            ),
          ),

          const SizedBox(height: 14),

          // Change Password button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                _showChangePasswordDialog(context);
              },
              icon: const Icon(Icons.lock_outline),
              label: const Text('Change Password'),
              style: _buttonStyle(),
            ),
          ),
        ],
      ),
    );
  }

  // Common button style
  static ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: _buttonColor,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  // Emergency Contact Popup
  static void _showEmergencyContactDialog(BuildContext context) {
    final nameController = TextEditingController();
    final contactController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: _popupGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Spacer(),
                          const Text(
                            'Add Your Human Support Team',
                            style: TextStyle(
                              color: _ink,
                              fontSize: 13,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                            },
                            icon: const Icon(
                              Icons.cancel_outlined,
                              size: 24,
                              color: _ink,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      _fieldLabel('Name'),

                      _inputField(
                        controller: nameController,
                        hint: 'Enter contact name',
                      ),

                      const SizedBox(height: 12),

                      _fieldLabel('Contact Number'),

                      _inputField(
                        controller: contactController,
                        hint: 'Enter contact number',
                        keyboardType: TextInputType.phone,
                      ),

                      const SizedBox(height: 24),

                      Center(
                        child: SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () {
                              final name = nameController.text.trim();
                              final contact =
                                  contactController.text.trim();

                              if (name.isEmpty || contact.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please enter the name and contact number.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              // TODO: Save the emergency contact
                              // using your backend or database.

                              Navigator.pop(dialogContext);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Input validated. Connect your backend to save the contact.',
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _buttonColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: const Text('Add'),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      const Text(
                        'Even Baymax knows that people need people.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      nameController.dispose();
      contactController.dispose();
    });
  }

  // Change Password Popup
  static void _showChangePasswordDialog(BuildContext context) {
    final usernameController = TextEditingController();
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: _popupGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Spacer(),
                          const Text(
                            'Change password here',
                            style: TextStyle(
                              color: _ink,
                              fontSize: 13,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                            },
                            icon: const Icon(
                              Icons.cancel_outlined,
                              size: 24,
                              color: _ink,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      _fieldLabel('Username'),

                      _inputField(
                        controller: usernameController,
                        hint: 'Enter username',
                      ),

                      const SizedBox(height: 12),

                      _fieldLabel('Current Password'),

                      _inputField(
                        controller: currentPasswordController,
                        hint: 'Enter current password',
                        obscureText: true,
                      ),

                      const SizedBox(height: 12),

                      _fieldLabel('New Password'),

                      _inputField(
                        controller: newPasswordController,
                        hint: 'Enter new password',
                        obscureText: true,
                      ),

                      const SizedBox(height: 12),

                      _fieldLabel('Confirm Password'),

                      _inputField(
                        controller: confirmPasswordController,
                        hint: 'Confirm new password',
                        obscureText: true,
                      ),

                      const SizedBox(height: 28),

                      Center(
                        child: SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () {
                              final username =
                                  usernameController.text.trim();
                              final currentPassword =
                                  currentPasswordController.text;
                              final newPassword =
                                  newPasswordController.text;
                              final confirmPassword =
                                  confirmPasswordController.text;

                              if (username.isEmpty ||
                                  currentPassword.isEmpty ||
                                  newPassword.isEmpty ||
                                  confirmPassword.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please complete all fields.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              if (newPassword != confirmPassword) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'New password and confirmation do not match.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              if (newPassword.length < 8) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Password must contain at least 8 characters.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              // TODO: Send the password change request
                              // to your backend for authentication
                              // and secure password updating.

                              Navigator.pop(dialogContext);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Input validated. Connect your backend to change the password.',
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _buttonColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: const Text('Save'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      usernameController.dispose();
      currentPasswordController.dispose();
      newPasswordController.dispose();
      confirmPasswordController.dispose();
    });
  }

  // Field label
  static Widget _fieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        label,
        style: const TextStyle(
          color: _ink,
          fontSize: 11,
        ),
      ),
    );
  }

  // White input field
  static Widget _inputField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return SizedBox(
      height: 36,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(
          fontSize: 12,
          color: _ink,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 11,
            color: Colors.black45,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(
              color: Color(0xFF9CA88B),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}

const Color baymaxPink = Color(0xFFF3D6D6);
const Color baymaxPinkLight = Color(0xFFFFF4EF);
const Color baymaxSage = Color(0xFFD9E2C8);
const Color baymaxSageDark = Color(0xFF788C62);
const Color baymaxInk = Color(0xFF292A2B);
const Color baymaxMuted = Color(0xFF747474);

/// Wellness History Page for DrBayMax.
/// This page uses sample values. Replace them with your saved wellness data.
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baymaxPink,
      body: SafeArea(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFE8E5), baymaxPink, Color(0xFFF7DEDE)],
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BayMaxBrand(),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _roundIconButton(
                      icon: Icons.arrow_back_rounded,
                     onTap: () {
                         Navigator.of(context).pushReplacement(
                           MaterialPageRoute(
                             builder: (_) => const HomePage(),
                           ),
                         );
                       },
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Your Wellness Journey',
                        style: TextStyle(
                          color: baymaxInk,
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Small steps count. Take a moment to see how you have been feeling.',
                  style: TextStyle(
                    color: baymaxMuted,
                    height: 1.4,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 20),
                const _WellnessMetricCard(
                  icon: Icons.psychology_alt_rounded,
                  title: 'Anxiety Episodes',
                  value: '4',
                  subtitle: 'Recorded this month',
                  tint: baymaxSage,
                ),
                const SizedBox(height: 12),
                const _WellnessMetricCard(
                  icon: Icons.sentiment_satisfied_alt_rounded,
                  title: 'Mood Summary',
                  value: 'Good',
                  subtitle: 'Your latest mood check-in',
                  tint: baymaxPinkLight,
                ),
                const SizedBox(height: 12),
                const _WellnessMetricCard(
                  icon: Icons.speed_rounded,
                  title: 'Average Stress',
                  value: '5.2/10',
                  subtitle: 'Based on your recorded check-ins',
                  tint: baymaxSage,
                ),
                const SizedBox(height: 12),
                const _WellnessMetricCard(
                  icon: Icons.bedtime_rounded,
                  title: 'Sleep',
                  value: '6.4 hours',
                  subtitle: 'Average per night',
                  tint: baymaxPinkLight,
                ),
                const SizedBox(height: 18),
                const _WeeklyTrendCard(),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.72),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.white, width: 1.2),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: baymaxSage,
                        child: Icon(Icons.favorite_rounded, color: baymaxSageDark),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'A little reminder',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: baymaxInk,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Your wellness journey is personal. These records can help you notice patterns, but they are not a medical diagnosis.',
                              style: TextStyle(
                                color: baymaxMuted,
                                height: 1.4,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BayMaxChatPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_outline_rounded),
                    label: const Text('Talk with BayMax'),
                    style: FilledButton.styleFrom(
                      backgroundColor: baymaxSageDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WellnessMetricCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color tint;

  const _WellnessMetricCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: baymaxInk.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 29, color: baymaxSageDark),
          ),
          const SizedBox(width: 14),
          Container(width: 1.5, height: 46, color: baymaxSageDark.withValues(alpha: 0.55)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: baymaxInk, fontSize: 13)),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    color: baymaxInk,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(subtitle, style: const TextStyle(color: baymaxMuted, fontSize: 10.5)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: baymaxInk, size: 25),
        ],
      ),
    );
  }
}

class _WeeklyTrendCard extends StatelessWidget {
  const _WeeklyTrendCard();

  @override
  Widget build(BuildContext context) {
    const values = [0.43, 0.58, 0.66, 0.39, 0.56, 0.61, 0.78];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      padding: const EdgeInsets.fromLTRB(17, 17, 17, 14),
      decoration: BoxDecoration(
        color: baymaxPinkLight,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: baymaxInk.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bar_chart_rounded, color: baymaxSageDark),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Weekly Wellness Trend',
                  style: TextStyle(
                    color: baymaxInk,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
              Text('This week', style: TextStyle(color: baymaxMuted, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 118,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(values.length, (index) {
                final barHeight = 28 + values[index] * 65;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: barHeight,
                          decoration: BoxDecoration(
                            color: index == 6 ? baymaxSageDark : baymaxSage,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(9),
                            ),
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          days[index],
                          style: const TextStyle(color: baymaxMuted, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Example visual only — connect your real check-in data to show your own trend.',
            style: TextStyle(color: baymaxMuted, fontSize: 10, height: 1.3),
          ),
        ],
      ),
    );
  }
}

class BayMaxBrand extends StatelessWidget {
  const BayMaxBrand({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.favorite_border_rounded, color: baymaxSageDark, size: 35),
              SizedBox(width: 8),
              Text(
                'DrBayMax',
                style: TextStyle(
                  color: Color(0xFF573B3B),
                  fontSize: 29,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.8,
                ),
              ),
            ],
          ),
          Text(
            'Understand Your Feelings. Find Your Calm.',
            style: TextStyle(color: baymaxInk, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

Widget _roundIconButton({
  required IconData icon,
  required VoidCallback onTap,
}) {
  return Material(
    color: Colors.white.withValues(alpha: 0.8),
    shape: const CircleBorder(),
    child: InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: SizedBox(
        width: 40,
        height: 40,
        child: Icon(icon, color: baymaxInk, size: 21),
      ),
    ),
  );
}


/// Demo chat page included so the HistoryPage's button can navigate to it.
/// For a real AI chat, connect _sendMessage to your backend/chat API.
class BayMaxChatPage extends StatefulWidget {
  const BayMaxChatPage({super.key});

  @override
  State<BayMaxChatPage> createState() => _BayMaxChatPageState();
}

class _BayMaxChatPageState extends State<BayMaxChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text: "Hello, Human! I'm Baymax, your wellness companion. I'm here to listen and help you find your calm.",
      isBaymax: true,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage([String? suggestedMessage]) {
    final text = (suggestedMessage ?? _controller.text).trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isBaymax: false));
      _messages.add(const _ChatMessage(
        text: "Thank you for sharing that with me. Let's take this one step at a time. What feels most important to you right now?",
        isBaymax: true,
      ));
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baymaxPink,
      body: SafeArea(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFE8E5), baymaxPink, Color(0xFFF7DEDE)],
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
                child: Column(
                  children: [
                    const BayMaxBrand(),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        _roundIconButton(
                          icon: Icons.arrow_back_rounded,
                          onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const HomePage(),
                                ),
                              );
                            },
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Chat with BayMax',
                            style: TextStyle(
                              color: baymaxInk,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const CircleAvatar(
                          backgroundColor: baymaxSage,
                          child: Icon(Icons.smart_toy_rounded, color: baymaxSageDark),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: baymaxSage,
                            child: Icon(Icons.smart_toy_rounded, color: baymaxSageDark),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'You do not have to figure everything out at once. We can take it one step at a time.',
                              style: TextStyle(color: baymaxInk, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'TRY ASKING...',
                      style: TextStyle(
                        color: baymaxMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _suggestion('I feel anxious', Icons.spa_outlined),
                        _suggestion('Help me relax', Icons.self_improvement_rounded),
                        _suggestion('Help me sleep better', Icons.bedtime_outlined),
                      ],
                    ),
                    const SizedBox(height: 18),
                    ..._messages.map((message) => _MessageBubble(message: message)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.45),
                  boxShadow: [
                    BoxShadow(
                      color: baymaxInk.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.9),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 9),
                    Material(
                      color: baymaxSageDark,
                      shape: const CircleBorder(),
                      child: IconButton(
                        onPressed: _sendMessage,
                        icon: const Icon(Icons.send_rounded, color: Colors.white),
                        tooltip: 'Send message',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _suggestion(String label, IconData icon) {
    return ActionChip(
      avatar: Icon(icon, size: 18, color: baymaxSageDark),
      label: Text(label),
      onPressed: () => _sendMessage(label),
      backgroundColor: baymaxSage,
      side: BorderSide.none,
      labelStyle: const TextStyle(color: baymaxInk, fontSize: 12),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isBaymax;

  const _ChatMessage({required this.text, required this.isBaymax});
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final alignment =
        message.isBaymax ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final color = message.isBaymax ? Colors.white : baymaxSage;
    final radius = message.isBaymax
        ? const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(18),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(6),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(18),
          );

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.78,
          ),
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.95),
            borderRadius: radius,
            boxShadow: [
              BoxShadow(
                color: baymaxInk.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            message.text,
            style: const TextStyle(color: baymaxInk, height: 1.35, fontSize: 13),
          ),
        ),
      ],
    );
  }
}
