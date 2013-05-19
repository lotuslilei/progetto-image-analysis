#ifndef SEGMENT_H
#define SEGMENT_H

class Segment {

	int id;
	bool valid;

	float segmentLength() const;

public:

	int x1;
	int y1;
	int x2;
	int y2;

	Segment();
	Segment(int x1, int y1, int x2, int y2);

	int getID() const { return id; };
	void setID(int id) { this->id = id; };

	bool isValid() const { return valid; } ;
	void setValid(bool valid) { this->valid = valid; };

	bool operator== (const Segment& b) const;

	bool operator< (const Segment& b) const;

	static Segment getInvalidLine();
};

class CandidateSegments {

public:

	CandidateSegments(Segment l1, Segment l2);

	Segment l1;
	Segment l2;
};

#endif
