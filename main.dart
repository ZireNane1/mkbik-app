import 'package:flutter/material.dart';

void main() => runApp(const EventApp());

class EventApp extends StatelessWidget {
  const EventApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
    home: const MainNavigationScreen(),
  );
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _idx = 0;
  final List<Widget> _tabs = [const EventListScreen(), const ProfileScreen()];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: _tabs[_idx],
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _idx,
      onTap: (i) => setState(() => _idx = i),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Мероприятия'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
      ],
    ),
  );
}

class Event {
  final String id, title, desc, date, loc;
  Event({required this.id, required this.title, required this.desc, required this.date, required this.loc});
}

final List<Event> demoEvents = [
  Event(id: '1', title: 'Студсовет МКБиК', desc: 'Обсуждение планов на семестр.', date: '18.06.2026 в 14:00', loc: 'Актовый зал'),
  Event(id: '2', title: 'Турнир CS', desc: 'Соревнования по Counter-Strike.', date: '22.06.2026 в 15:30', loc: 'Компьютерный класс №4'),
  Event(id: '3', title: 'Семинар по дипломам', desc: 'Разбор типичных ошибок оформления.', date: '25.06.2026 в 10:00', loc: 'Аудитория 204'),
];

List<String> registeredIds = [];

class EventListScreen extends StatelessWidget {
  const EventListScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Анонсы мероприятий', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
    body: ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: demoEvents.length,
      itemBuilder: (context, i) {
        final e = demoEvents[i];
        return Card(
          elevation: 4, margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(e.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(children: [const Icon(Icons.calendar_today, size: 16, color: Colors.grey), const SizedBox(width: 6), Text(e.date)]),
                const SizedBox(height: 4),
                Row(children: [const Icon(Icons.location_on, size: 16, color: Colors.grey), const SizedBox(width: 6), Text(e.loc)]),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blueAccent),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => EventDetailScreen(event: e))).then((_) => (context as Element).markNeedsBuild()),
          ),
        );
      },
    ),
  );
}

class EventDetailScreen extends StatefulWidget {
  final Event event;
  const EventDetailScreen({super.key, required this.event});
  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  @override
  Widget build(BuildContext context) {
    bool isReg = registeredIds.contains(widget.event.id);
    return Scaffold(
      appBar: AppBar(title: const Text('Детали события')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.event.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
            const SizedBox(height: 15),
            Row(children: [const Icon(Icons.access_time, color: Colors.orange), const SizedBox(width: 10), Text(widget.event.date)]),
            const SizedBox(height: 10),
            Row(children: [const Icon(Icons.place, color: Colors.redAccent), const SizedBox(width: 10), Text(widget.event.loc)]),
            const Divider(height: 30),
            const Text('Описание:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(widget.event.desc, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: isReg ? Colors.grey : Colors.blueAccent, foregroundColor: Colors.white),
                onPressed: () => setState(() => isReg ? registeredIds.remove(widget.event.id) : registeredIds.add(widget.event.id)),
                child: Text(isReg ? 'Вы записаны (Отменить)' : 'Записаться', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final userEvents = demoEvents.where((e) => registeredIds.contains(e.id)).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Личный кабинет', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Column(
                children: [
                  CircleAvatar(radius: 40, backgroundColor: Colors.blueAccent, child: Icon(Icons.person, size: 50, color: Colors.white)),
                  SizedBox(height: 10),
                  Text('Студент МКБиК', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('+7 (707) 123-4567', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text('Мои регистрации:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: userEvents.isEmpty
                ? const Center(child: Text('Нет записей.', style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    itemCount: userEvents.length,
                    itemBuilder: (context, i) => Card(
                      color: Colors.blue.shade50,
                      child: ListTile(
                        title: Text(userEvents[i].title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(userEvents[i].date),
                        trailing: const Icon(Icons.check_circle, color: Colors.green),
                      ),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
