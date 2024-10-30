d_logic(computer).

% 定義 Canvas 的大小
canvas_width(20).
canvas_height(20).

% 創建空白的 Canvas
create_canvas(Canvas) :-
    canvas_height(Height),
    canvas_width(Width),
    length(Canvas, Height),
    maplist(lengths(Width), Canvas).

lengths(Width, Row) :-
    length(Row, Width),
    maplist(=( ' '), Row). % 初始化為空白

% 繪製圓形的規則
draw_circle(Canvas, CenterX, CenterY, Radius, Points, UpdatedCanvas) :-
    findall((X, Y), 
            (between(0, 360, Angle),
             rad(Angle, Radian),
             X is round(CenterX + Radius * cos(Radian)),
             Y is round(CenterY + Radius * sin(Radian)),
             X >= 1, X =< 20, Y >= 1, Y =< 20), 
            Points),
    place_points(Canvas, Points, UpdatedCanvas).

rad(N, Radian) :- Radian is N * pi / 180.

% 將計算出的點放在 Canvas 上
place_points(Canvas, [], Canvas). % 如果沒有點，返回原 Canvas
place_points(Canvas, [(X, Y)|Points], UpdatedCanvas) :-
    %Y1 is Y + 1, % 調整 Y 軸
    nth1(Y, Canvas, Row), % 找到第 Y 行
    replace(Row, X, 'O', NewRow), % 在該位置放置 'O'
    replace(Canvas, Y, NewRow, TempCanvas), % 更新 Canvas
    place_points(TempCanvas, Points, UpdatedCanvas). % 繼續放置其他點

replace([_|T], 1, New, [New|T]). % 替換第一個元素
replace([H|T], N, New, [H|R]) :- 
    N > 1, 
    N1 is N - 1, 
    replace(T, N1, New, R). % 替換其餘的元素

% 顯示 Canvas 的規則
display_canvas(Canvas) :-
    forall(member(Row, Canvas), 
           (   write(Row), nl)).

% 初始化並顯示 Canvas
start :-
    create_canvas(Canvas), % 創建空白的 Canvas
    draw_circle(Canvas, 10, 10, 5, _, UpdatedCanvas), % 在 Canvas 上繪製圓形並推斷 Points
    display_canvas(UpdatedCanvas). % 顯示 Canvas

% 定義計算機的能力與 Canvas 繪圖的關係
can_draw_circle(computer, Canvas) :-
    can_read_logic(computer), % 確認計算機可以讀取邏輯
    draw_circle(Canvas, 10, 10, 5, _, _). % 認可計算機能夠在 Canvas 上繪製圓形

