% Facts
can_read_logic(computer).

% Canvas dimensions
canvas_width(50).
canvas_height(50).

% Create an empty canvas
create_canvas(Canvas) :-
    canvas_height(Height),
    canvas_width(Width),
    length(Canvas, Height),
    maplist(lengths(Width), Canvas).

lengths(Width, Row) :-
    length(Row, Width),
    maplist(=( '.'), Row). % Initialize canvas with dots

% Draw a circle on the canvas
draw_circle(Canvas, CenterX, CenterY, Radius, Points, UpdatedCanvas) :-
    % Define finer angle increments for a smoother circle
    findall((X, Y), (
        between(0, 720, AngleDiv2),         % Use 0.5-degree increments by doubling the angle range
        Angle is AngleDiv2 / 2,             % Convert the increment back to the original angle in degrees
        rad(Angle, Radian),
        Xf is CenterX + Radius * cos(Radian),
        Yf is CenterY + Radius * sin(Radian),
        X is round(Xf),                     % Round X for canvas mapping
        Y is round(Yf),                     % Round Y for canvas mapping
        X >= 1, X =< 50, Y >= 1, Y =< 50  % Adjusted grid size to 50x50
    ), Points),
    % Place points on the canvas
    place_points(Canvas, Points, UpdatedCanvas).

% Helper predicate to convert degrees to radians
rad(Degrees, Radians) :-
    Radians is Degrees * pi / 180.

% Place points on the canvas by replacing existing points
place_points(Canvas, [], Canvas). % Base case: no points to place
place_points(Canvas, [(X, Y)|Points], UpdatedCanvas) :-
    Y1 is Y + 1, % Account for 1-based indexing of nth1
    nth1(Y1, Canvas, Row), % Get the row to modify
    replace(Row, X, 'O', NewRow), % Replace the element at position X in the row with 'O'
    replace(Canvas, Y1, NewRow, TempCanvas), % Replace the row in the canvas
    place_points(TempCanvas, Points, UpdatedCanvas). % Recurse for remaining points

% Replace an element in a list at a given position
replace([_|T], 1, New, [New|T]). % Replace at head of list
replace([H|T], N, New, [H|R]) :-
    N > 1,
    N1 is N - 1,
    replace(T, N1, New, R). % Recurse to find the correct position

% Display the canvas
display_canvas(Canvas) :-
    forall(member(Row, Canvas),
           (write(Row), nl)).

% Main predicate to initialize and draw the canvas
start :-
    create_canvas(Canvas), % Create an empty canvas
    draw_circle(Canvas, 10, 10, 5, Points, UpdatedCanvas), % Draw circle on canvas
    display_canvas(UpdatedCanvas). % Display the updated canvas

% Fact that the computer can draw a circle on a canvas
can_draw_circle(computer, Canvas) :-
    can_read_logic(computer),
    draw_circle(Canvas, 10, 10, 5, Points, _).




























