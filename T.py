import numpy as np
import sys
import os
import datetime
import matplotlib.pyplot as plt
from shutil import copyfile
plt.rcParams.update({'figure.figsize': (20,20)})
plt.matplotlib.rcParams.update({'font.size': 15})
import matplotlib.image as mpimg
import matplotlib
import matplotlib.patches as mpatches
from matplotlib import lines
import time
# import tables
# import prettytable
from collections import defaultdict
from shutil import move

Rev = [
"(defconstant *RRMcall*  (&& (SomF (-P- Action_State_dn_6_1)) (ALWF (&& (!! (-P- hold)) (!! (-P- RRM_1)) (!! (-P- RRM_2))(-A- i hazard_indexes (-> (-P- HAZARD_OCCURED i ) (-P- RRM_4)))))))",
"(defconstant *RRMcall* (&&(SomF (-P- Action_State_dn_6_1))(ALWF (&& (!! (-P- RRM_1)) (!! (-P- RRM_2))(-P- RRM_5)(-A- i `(2 3 4 6 7 8 10 11 12 14 15 16 18 19 20 22 23 24 26 27 28) (-> (-P- RRM_4) (-P- HAZARD_OCCURED i )))))))",
"(defconstant *RRMcall*(ALWF (&& (!! (-P- RRM_1)) (!! (-P- RRM_4)) (-A- i hazard_indexes (-> (-P- RRM_2) (-P- HAZARD_OCCURED i ))))))",
"(defconstant *RRMcall* (&& (ALwF (-P- RRM_3))(SomF (-P- Action_State_dn_3_1))))",
"(defconstant *RRMcall* (&& (ALwF (-P- RRM_1))(SomF (-P- Action_State_dn_6_1))(-A- i hazard_indexes (-> (-P- HAZARD_OCCURED i ) (-P- RRM_4)))))",
# "(defconstant *RRMcall* (&&(eval (list `alwf (append `(&&) (loop for i in hazard_indexes collect `(-> (|| ,(read-from-string (format nil \"(Hazard_Risk_~A= 1) \" i)) ,(read-from-string (format nil \"(Hazard_Risk_~A= 2) \" i)) )(UNTIL_IE (-P- RRM_4) ,(read-from-string (format nil \"(Hazard_Risk_~A= 0)\" i)))))))) (ALWF(-> (-P- RRM_4)(hazardous_sit))) (ALWF (&& (!! (-P- RRM_1)) (!! (-P- RRM_2)) (!! (-P- RRM_3)) )) ))"
]
#############################parsing the output file#############################

class switch(object):
    def __init__(self, value):
        self.value = value
        self.fall = False

    def __iter__(self):
        """Return the match method once, then stop"""
        yield self.match
        raise StopIteration

    def pallet(element):
        for case in switch(elelemnt):
            if case('head'):
                return (1500,480)
                break
            if case('hand'):
                return (1400,520)
                break
            if case('ro'):
                return (1350,520)
                break
            if case():
                print ("something is wrong with coordinates of the object!")

    def match(self, *args):
        """Indicate whether or not to enter a case suite"""
        if self.fall or not args:
            return True
        elif self.value in args: # changed for v1.5, see below
            self.fall = True
            return True
        else:
            return False
def element_co(strin,element):
    for case in switch(strin):
        if case([1]):
            return (750,900)
        if case([2]):
	        return (800,900)
        if case([3]):
            return (200,1100)
        if case([4]):
            return (700,500)
        if case([5]):
	        return (900,500)
        if case([6]):
            return (200,500)
        if case([7]):
            return (750,200)
        if case([8]):
	        return (800,200)
        if case([9]):
	        return (200,200)
        if case():
	        print ("something is wrong with coordinates of the object!"+ str(strin) + str(element))

def read_Layout(filename):
    file = open(filename,"r")
    line = ""
    index = ""
    elements =[]
    Num=""
    while "(defvar L_indexes" not in line:
        line = file.readline()
    if "collect" in line:
    	str1 = line.split("to ")
    	index = str1[1].split("collect")[0]
    file.close()
    return index

def read_RRM(filename):
    file = open(filename,"r")
    line = ""
    i = 0
    rrms = defaultdict(list)
    while "  )))))" not in line:
        line = file.readline()
        if ";;" in line:
           i += 1
           rrms[i] = " " + line.split(';;')[1].replace("\n","")
    file.close()
    return rrms

def read_agents(filename):
    file = open(filename,"r")
    line = ""
    index = ""
    elements =[]
    Num=""
    if filename == "ORL-Module/O.lisp":
        target_string1 = "(defvar body_indexes"
        target_string2 = "(defvar operatorNum"
        numSplit = "operatorNum "
    elif filename == "ORL-Module/R.lisp":
        target_string1 = "(defvar ro_indexes"
        target_string2 = "(defvar roNum"
        numSplit = "roNum "
    while target_string1 not in line:
        if target_string2 in line:
            Num = line.split(numSplit)[1].split(")")[0]
        line = file.readline()
    if "collect" in line:
    	str1 = line.split("to ")
    	index = str1[1].split("collect")[0]
    elif "`("  in line:
    	str1 = line.split("`(")
    	elements = str1[1].split(" ")
    	elements[len(elements)-1] = elements[len(elements)-1].split(")")[0]
    	index = len(elements)
    file.close()
    return index, elements, Num

def read_hazards():
    file = open("Hazards.lisp","r")
    line = ""
    index = ""
    hazardname =  defaultdict(list)
    while  "(defvar hazard" not in line:
    	line = file.readline()
    if "collect" in line:
    	str1 = line.split("to ")
    	index = str1[1].split("collect")[0]
    while ";;*** hits" not in line:
        line = file.readline()
    i = 0
    while ")))" not in line:
        i += 1
        line = file.readline()
        if "hit" in line:
            hazardname[i] = "Tr on " + line.split("`")[1].split("_area")[0] + " by " + line.split("`")[2].split(" ")[0]  #+ " of robot " + line.split("`")[2].split(" ")[1] + " \n"
        if "entg" in line:
            hazardname[i] = "Qs on " + line.split("`")[1].split("_area")[0] + " by " + line.split("`")[2].split(" ")[0] # " of robot " + line.split("`")[2].split(" ")[1] + " \n"

    file.close()
    return index, hazardname

def read_actions ():
    file = open("TaskLib/T1.lisp","r")
    line = ""
    index = ""
    actions = ""
    TaskNum = 0
    actions =  defaultdict(list)
    while  "(defvar action" not in line:
    	line = file.readline()
    if "collect" in line:
    	str1 = line.split("to ")
    	index = str1[1].split("collect")[0]
    while ";;List of actions" not in line:
            if "(defvar T" in line:
                TaskNum += 1
            line = file.readline()
    line = file.readline()
    i = 0
    while ";; " in line:
        i += 1
        line = file.readline()
        if ';;' in line:
            actions[i] = line.split(";;")[1]
    file.close()
    return index, actions, TaskNum

def parse_outPut ():
    line = ""
    bool_set = set()
    tspace = -1
    records = {}
    file = open("output.hist.txt","r")
    for line in file:
        if "------ time" in line:
            tspace += 1
        elif line.startswith("------ end") or line.strip() == "**LOOP**":
            pass
        else:
            value = tspace
            line = line.split("\n")[0]
            line=line.replace(" ","")
            bool_set.add(line)
            if line in records:
                records[line].append(value)
            else:
             records[line] = [value]
    return tspace, records

def parse_hazards(hazard_indexes, records,step):
    hazards = defaultdict(list)
    risks = defaultdict(list)
    severities = defaultdict(list)
    for t in range (0 , step+1):
        for h in range (1 , int(hazard_indexes) + 1):
            hzd = "HAZARD_OCCURED_"+str(h)
            rsk = "HAZARD_RISK_" + str(h)
            svty= "HAZARD_SE_" + str(h)
            if hzd in records:
                if t in records[hzd]:
                    hazards[t].append(h)
                    for r in records:
                        if rsk+"=0" in r and t in records[r]:
                            risks[t].append('0')
                        if rsk+"=1" in r and t in records[r]:
                            risks[t].append('1')
                        if rsk+"=2" in r and t in records[r]:
                            risks[t].append('2')
                    for r in records:
                        if svty+"=0" in r and t in records[r]:
                            severities[t].append('0')
                        if svty+"=1" in r and t in records[r]:
                            severities[t].append('1')
                        if svty+"=2" in r and t in records[r]:
                            severities[t].append('2')
    return (hazards,risks,severities)

def parse_positions (element_index, records,step, ID, l_index, agenttype):
    result = {}
    for i in element_index:
        result[i] = find_position (i, records,step, ID, l_index,agenttype)
    return result

def find_position (i, records,step, task_id, l_index,agenttype):
    position = defaultdict(list)
    for ID in range (1 , int(task_id)+1):
        for t in range (0 , step+1):
            for l in range (1 , int(l_index) + 1):
                if agenttype== 'ro':
                    element = str(i).upper() + "_" + str(ID)+"_IN_L_" + str(l)
                elif agenttype== 'op':
                    element = "OPERATOR_" + str(ID)+ "_" + str(i).upper() + "_IN_L_" + str(l)
                if element in records:
                    if t in records[element]:
                        position[t].append(l)
    return position

def parse_actions (actions_index,taskid,step,records):
    executing_actions = defaultdict(list)
    safe_executing_actions = defaultdict(list)
    ns_actions = defaultdict(list)
    wt_actions = defaultdict(list)
    dn_actions = defaultdict(list)
    hd_actions = defaultdict(list)
    for t in range (0 , step+1):
        for i in range(1, int(actions_index)+1, 1):
            exe = "ACTION_STATE_EXE_"+ str(i) + "_"+ str(taskid)
            exrm = "ACTION_STATE_EXRM_" + str(i) + "_"+ str(taskid)
            ns = "ACTION_STATE_NS_" + str(i) + "_"+ str(taskid)
            wt = "ACTION_STATE_WT_" + str(i) + "_"+ str(taskid)
            dn = "ACTION_STATE_DN_" + str(i) + "_"+ str(taskid)
            hd = "ACTION_STATE_HD_" + str(i) + "_"+ str(taskid)
            for r in records:
                if exe in r:
                    if t in records[r]:
                        executing_actions[t].append(i)
                elif hd in r:
                    if t in records[r]:
                        hd_actions[t].append(i)
                elif exrm in r:
                    if t in records[r]:
                        safe_executing_actions[t].append(i)
                elif ns in r:
                    if t in records[r]:
                        ns_actions[t].append(i)
                elif wt in r:
                    if t in records[r]:
                        wt_actions[t].append(i)
                elif dn in r:
                    if t in records[r]:
                        dn_actions[t].append(i)
    return  ns_actions, wt_actions, executing_actions, safe_executing_actions, dn_actions, hd_actions

def parse_attributes (step, records, opid):
    velocity = defaultdict(list)
    force = defaultdict(list)
    separation = defaultdict(list)
    operator = "OPERATOR_" + str(opid)
    for t in range (0 , step+1):
        for r in records:
            for x in ("HIGH", "MID","LOW", "NONE"):
                if x in r and t in records[r]:
                 if "VELOCITY" in r and velocity[t] != "CRITICAL":
                     if (velocity[t] == "NORMAL" and x == "LOW") or (velocity[t] == "LOW" and x == "NONE"):
                         break
                     velocity[t] = x
                 elif  "FORCE" in r and force[t] != "CRITICAL":
                     if force[t] == "NORMAL" and x == "LOW":
                         break
                     force[t] = x
            for x in ("CLOS", "FAR","VERY_FAR"):
                if x in r and operator in r and t in records[r]:
                 if "SEPARATION" in r and separation[t] != "CLOS":
                     if force[t] == "FAR" and x == "VERY_FAR":
                         break
                     separation[t] = x
    return separation, velocity, force

def parse_errors (step, records, opid,actions_index,actions):
    errors = defaultdict(list)
    for t in range (0 , step+1):
    	for r in records:
            for x in ('REPETITION', 'OMISSION', 'LATE', 'EARLY_START', 'EARLY_END', 'INTRUSION','ERR_F', 'ERR_L' ):
                if x in r and t in records[r]:
                    if x == 'EARLY_START' or x == 'EARLY_END' or x == 'ERR_F' or x == 'ERR_L':
                        act = r.split("_",1)[1].split("_",1)[1].split("_",1)[0]
                        s = x.lower().replace("_", " ") + " of " + actions[int(act)]
                        errors[t].append(s)
                    else:
                        act = r.split("_",1)[1].split("_",1)[0]
                        s = x.lower() + " of " + actions[int(act)]
                        errors[t].append(s)
    return errors

def parse_rrms (step, records,rrm_names):
    rrms = defaultdict(list)
    for t in range (0 , step+1):
        for r in records:
            if 'NO_RRM' in r and t in records[r]:
                rrms[t].append("no RRM")
            elif 'RRM' in r and t in records[r] and 'S' not in r:
                rrms[t].append(rrm_names[int(r.split("_",1)[1])])
    return rrms

def parse_moving_dirs (step, records):
    # ro_parts = ['BASE','ENDEFF','LINK1','LINK2']
    ro_parts = ['BASE','ENDEFF']
    # op_parts = ['HEAD','CHEST','ARM','LEG']
    op_parts = ['HEAD','ARM']
    dirs =  defaultdict(list)
    for t in range (0 , step+1):
        for r in records:
            for ro in ro_parts:
                for op in op_parts:
                        if 'MOVEDIRECTION_' in r and t in records[r] and ro in r and op in r:
                            if 'VERY_FAR' in r:
                                dirs[t].append (op + ' and '+ ro + ' VERY_FAR')
                            elif 'CLOS' in r:
                                dirs[t].append (op + ' and '+ ro + ' CLOS')
                            else:
                                dirs[t].append (op + ' and '+ ro + ' FAR' )
    return dirs

def action_end(dn_actions,action_num):
    for d in dn_actions:
        if (int(action_num) in dn_actions[d]):
            return d
#############################creating the layout vision#############################
# create the figure and the axis in one shot
def create_legend (step,plt,actions_num,executing_actions,safe_executing_actions,hazards, risks,hazard_names,action_names,errors,op_head,force,velocity,rrms,dirs):
    legendexe = legendexrm = ""
    legendhz = "hazards: "
    legenderrors = "errors: "
    for a in  executing_actions:
        legendexe +=  str(action_names[a])
    for a in  safe_executing_actions:
        legendexrm +=  str(action_names[a])
    riskcounter = 0
    for h in hazards:
        legendhz += str(hazard_names[h]).replace("_1","") + "with risk " + str(risks[riskcounter]) + "\n"
        riskcounter += 1
    # for e in errors:
    #     legenderrors += str(e)
    s = "force: "+ force.lower()+", velocity: "+ velocity.lower() + "\n Active RRM: "+ ' '.join(rrms) + "\n"+ ','.join(dirs)
    plt.xlabel(legendhz)
    plt.text(1300,600, s, bbox={'facecolor':'none', 'edgecolor':'none','alpha':0.5, 'pad':0}, rotation='vertical')
    plt.ylabel("time "+str(step))
    # plt.title("executing: " + legendexe + legendexrm + "\n" + legenderrors)
    plt.title("executing: " + legendexe + legendexrm )
    return plt,

def draw_layout(base , ee, l1, l2, op_head, op_hand, step, task_id):

	fig, ax = plt.subplots()
	layoutA = mpimg.imread("layoutA.png")
	ax.imshow(layoutA)

	# Turn off tick labels
	# ax.set_yticklabels([])
	# ax.set_xticklabels([])
	#
	L_head = mpatches.Circle((element_co(op_head,'head')[0],element_co(op_head,'head')[1]),60, fill=False, color="green")
	ax.add_patch(L_head)
	#
	L_hand = lines.Line2D([element_co(op_head,'head')[0], element_co(op_hand,'hand')[0]],[element_co(op_head,'head')[1], element_co(op_hand,'hand')[1]], lw=20, color="green",zorder=1)
	ax.add_line(L_hand)
	#
	L_ee = mpatches.Circle((element_co(ee,'ro')[0],element_co(ee,'ro')[1]),15, color="blue",zorder=2)
	ax.add_patch(L_ee)
	#
	L_l1 = lines.Line2D([element_co(base,'ro')[0],element_co(l1,'ro')[0]],[element_co(base,'ro')[1], element_co(l1,'ro')[1]], lw=9., color="blue",zorder=2)
	ax.add_line(L_l1)
	#
	L_l2 = lines.Line2D([element_co(l1,'ro')[0], element_co(ee,'ro')[0] ],[element_co(l1,'ro')[1], element_co(ee,'ro')[1]], lw=9., color="blue",zorder=2)
	ax.add_line(L_l2)
	#
	L_base = mpatches.Rectangle((element_co(base,'ro')[0]-50,element_co(base,'ro')[1]-50),700,250,angle=0.0, color="blue",fill=False)
    #
	ax.add_patch(L_base)

	return ax.patches,

#############################creating tables#############################
def safety_analysis_table (step,plt,actions_num,executing_actions,safe_executing_actions,hazards, risks,severities,hazard_names,action_names,separation, velocity, force):
    legendhz = " "
    legendrsk = " "
    legendsvty = executing = " "
    for h in hazards:
        legendhz += str(hazard_names[h]) + "\n"
    for r in risks:
        legendrsk += str(r) + "\n"
    for s in severities:
        legendsvty += str(s) + "\n"
    for a in  executing_actions:
        executing +=  str(action_names[a])

    GstateSA.add_row([step, executing, legendhz ,legendrsk,legendsvty,"9",force,velocity,separation])
    return GstateSA


# #############################executing zot and processing the output#############################
if __name__ == '__main__':
    chosen_rrm = 0
    done_end = [0,0,0,0,0]
    number_of_holds = [0,0,0,0,0]
    while (chosen_rrm < len(Rev)):
        with open("Rev.lisp",'w') as file:
            file.seek(0)
            file.write(Rev[chosen_rrm])
        os.system("zot Main.lisp")
        while not os.path.exists('output.hist.txt'):time.sleep(1)
        if os.path.isfile('output.hist.txt'):
            step , records = parse_outPut()
            hazard_num, hazard_names = read_hazards()
            action_num,action_names, task_id =read_actions()
            rrm_names = read_RRM("RRM.lisp")
            roPart_indexes,ro_segments, ro_num = read_agents("ORL-Module/R.lisp")
            body_indexes,op_segments, op_num = read_agents("ORL-Module/O.lisp")
            l_indexes = read_Layout("ORL-Module/L.lisp")
            # parse hazards
            # use as: if hazard_x is in  hazards[time], risks[time]
            hazards = parse_hazards(hazard_num, records, step)
            hazards, risks, severities = hazards[0], hazards[1], hazards[2]
            rrms = parse_rrms (step, records,rrm_names)
            #
            # parse ro positions
            # use as:  EndEff[time]
            ro_positions = parse_positions (ro_segments, records, step, 1, l_indexes, 'ro')
            EndEff, Base, Link1, Link2 = ro_positions['EndEff'], ro_positions['Base'], ro_positions['Link1'], ro_positions['Link2']
            # parse human positions
            # use as:  head[opId][time]
            leg= defaultdict(list)
            chest = defaultdict(list)
            arm = defaultdict(list)
            head = defaultdict(list)
            # for i in range (1 , int(op_num)+1):
            op_positions = parse_positions (op_segments, records, step, 1, l_indexes, 'op')
            leg_1, chest_1, arm_1, head_1 = op_positions['leg_area'], op_positions['chest_area'], op_positions['arm_area'], op_positions['head_area']

            op_positions = parse_positions (op_segments, records, step, 2, l_indexes, 'op')
            leg_2, chest_2, arm_2, head_2 = op_positions['leg_area'], op_positions['chest_area'], op_positions['arm_area'], op_positions['head_area']
            # parse actions
            # use executing_actions[time] to have list of exe actions at time
            executing_actions= defaultdict(list)
            safe_executing_actions = defaultdict(list)
            ns_actions = defaultdict(list)
            wt_actions = defaultdict(list)
            dn_actions = defaultdict(list)
            hd_actions = defaultdict(list)
            # for task one
            ns_actions, wt_actions, executing_actions, safe_executing_actions, dn_actions, hd_actions = parse_actions (action_num,1,step,records)
            #parse relative attributes
            # use as : velocity[t]
            # for i in range (1 , int(op_num)+1):
            attributes_1 =parse_attributes (step, records, 1)
            separation_1 , velocity_1 , force_1 = attributes_1[0] , attributes_1[1], attributes_1[2]

            attributes_2 =parse_attributes (step, records, 2)
            separation_2 , velocity_2 , force_2 = attributes_2[0] , attributes_2[1], attributes_2[2]
            # #parse errors
            # errors = parse_errors (step, records, 1,action_num,action_names)
            #parse directions
            dirs = parse_moving_dirs (step, records)
            index = 1
            newpath = 'Output'
            while 1:
                name = str(index)
                if not os.path.exists(newpath+name):
                    os.makedirs(newpath+name)
                    folder = newpath+name
                    break
                else:
                    index += 1
            move("output.1.txt", folder+"/output.1.txt")
            move("output.hist.txt", folder+"/output.hist.txt")
            move("output.smt.txt", folder+"/output.smt.txt")
            move("REv.lisp", folder+"/REv.lisp")
            for i in range (0, step+1):
                draw_layout(Base[i],EndEff[i], Link1[i], Link2[i], head_1[i], arm_1[i], i, 1)
                create_legend (i,plt, action_num, executing_actions[i], safe_executing_actions[i],hazards[i], risks[i],hazard_names,action_names,'',head_1[i],force_1[i],velocity_1[i],rrms[i],dirs[i])
                plt.savefig(folder+"/Time"+str(i)+".png")

        f2 = open(folder+'/Execution_seq.txt','w')
        #list of executing actions
        for i in range (0, step+1):
            f2.write( "\n ns actons:")
            f2.write(str(ns_actions[i]))
            f2.write(" \n wt actons:")
            f2.write( str(wt_actions[i]))
            f2.write( " \n executing actons:")
            f2.write( str(executing_actions[i]))
            f2.write("\n safe-executing actons:")
            f2.write(str(safe_executing_actions[i]))
            f2.write("\n dn actons: ")
            f2.write(str(dn_actions[i]))
            f2.write("\n______________________________________")

        chosen_rrm += 1
