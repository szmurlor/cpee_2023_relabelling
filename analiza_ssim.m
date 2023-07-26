% File responsible for structural soimialrity analysis

% DATADIR = '/home/szmurlor/Nextcloud/ALEX_obrazy_all';
DATADIR = 'C:\Users\szmurlor\Nextcloud\ALEX_obrazy_all';
classes = dir(DATADIR)
idx = arrayfun( @(s) '.'~=s.name(1:1), classes);
classes = classes(idx);
n = length(classes)

A = zeros(n);
for r = 1:n
    r
    for c = 1:n
        c
        rn = classes(r);
        cn = classes(c);
        filesr = dir( [DATADIR, '\', rn.name, '\', '*.jpg'] );
        filesc = dir( [DATADIR, '\', cn.name, '\', '*.jpg'] );
        s = 0;
        sn = 0;
        if c <= r
            for fri = 1:length(filesr)
                for fci = 1:length(filesc)
                    frn = filesr(fri);
                    fcn = filesc(fci);
                    if (strcmp([rn.name, '\', frn.name], [cn.name, '\',fcn.name]) ~= 1)
                        Ir = imread([DATADIR, '\', rn.name, '\',frn.name]);
                        Ic = imread([DATADIR, '\', cn.name, '\',fcn.name]);
                        s = s + ssim(Ir, Ic);
                        sn = sn + 1;
                    else
                        fprintf("Ten sam: %s == %s\n", [rn.name, '\', frn.name], [cn.name, '\',fcn.name]);
                    end
                end
            end
            A(r,c) = s/sn;
            A(r,c)
            save("A_ssim.mat", 'A')
        end
    end
end
%imshow(I)
imagesc(A)
%set(gca, 'XTick', 1:n); % center x-axis ticks on bins
%set(gca, 'YTick', 1:n); % center y-axis ticks on bins
%set(gca, 'XTickLabel', arrayfun(@(c) str2num(c.name), classes)); % set x-axis labels
%set(gca, 'YTickLabel', arrayfun(@(c) str2num(c.name), classes)); % set y-axis labels
title('Structural Similarity', 'FontSize', 10); % set title
xlabel("Classes 1-68")
ylabel("Classes 1-68")
colormap('jet')
colorbar

