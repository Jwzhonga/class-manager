"""填入24新能源班课表（修正版）— H14：按学期操作，不误清其他学期"""
import sys
from app import app, db, Schedule, ScheduleImage, Semester

schedule_data = {
    (0, 1): ('数学', '张生武', False),
    (0, 2): ('英语', '齐立', False),
    (0, 3): ('语文', '李丽', False),
    (0, 6): ('体育', '白刚', False),
    (0, 7): ('班会', '金万钟', False),
    (1, 1): ('混合动力汽车构造、原理与检修', '金万钟', True),
    (1, 2): ('混合动力汽车构造、原理与检修', '金万钟', True),
    (1, 3): ('新能源汽车驱动系统构造与检修', '金万钟', True),
    (1, 5): ('新能源汽车驱动系统构造与检修', '金万钟', True),
    (1, 6): ('体育', '白刚', False),
    (1, 7): ('语文', '李丽', False),
    (2, 1): ('新能源汽车电气系统构造与检修', '金万钟', True),
    (2, 3): ('音乐鉴赏', '曾爽', False),
    (2, 5): ('体育', '白刚', False),
    (2, 6): ('语文', '李丽', False),
    (3, 1): ('数学', '金万钟', False),
    (3, 2): ('政治', '金哲', False),
    (3, 3): ('体育', '白刚', False),
    (3, 6): ('英语', '齐立', False),
    (3, 7): ('美术鉴赏', '张生科', False),
    (4, 7): ('数学', '张生武', False),
}

with app.app_context():
    # 目标学期：命令行参数 > 当前学期 > 第一个学期
    sem_id = None
    if len(sys.argv) > 1 and sys.argv[1].isdigit():
        sem_id = int(sys.argv[1])
    if sem_id is None:
        cur = Semester.query.filter_by(is_current=True).first()
        sem_id = cur.id if cur else None
    if sem_id is None:
        first = Semester.query.order_by(Semester.id).first()
        sem_id = first.id if first else None
    if sem_id is None:
        print('❌ 无任何学期，请先创建学期'); sys.exit(1)

    # 仅清空目标学期的课表（H14：不再清所有学期）
    Schedule.query.filter_by(semester_id=sem_id).delete()
    ScheduleImage.query.filter_by(semester_id=sem_id).delete()
    for (d, p), (course, teacher, is_training) in schedule_data.items():
        s = Schedule(day_of_week=d, period=p, course_name=course,
                     teacher=teacher, is_training=is_training, semester_id=sem_id)
        db.session.add(s)
    db.session.commit()
    count = Schedule.query.filter_by(semester_id=sem_id).count()
    print(f'已向学期#{sem_id}填入 {count} 条课程')
