% semg = LEN x CH

function pulse_vec = semg_find_pulse(semg, threshold)

len = length(semg);
ch = size(semg, 2);
pulse_vec = zeros(size(semg));

for i = 1 : ch
    for r = 2 : len
        if semg(r, i) > threshold
           diff = (semg(r, i) - semg(r - 1, i)) * ...
                    (semg(r - 1, i) - semg(r, i));
           if diff < 0
               pulse_vec(r, i) = semg(r, i);
               if semg(r, i) < 0
                   disp(threshold(i));
               end
           end
        end
    end
end


end